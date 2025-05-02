# frozen_string_literal: true

require "rails_helper"

RSpec.describe Twilio::SmsMessageService do
  let(:user) { create(:user) }
  let(:valid_phone) { "+15551234567" }
  let(:message) { "Hello there!" }
  let(:from_number) { "+19998887777" }

  let(:twilio_client) { instance_double(Twilio::REST::Client) }
  let(:message_list) { instance_double(Twilio::REST::Api::V2010::AccountContext::MessageList) }
  let(:message_instance) { instance_double(Twilio::REST::Api::V2010::AccountContext::MessageInstance, sid: "SM123456") }

  before do
    allow(Rails.application.credentials).to receive(:[])
      .with(Rails.env)
      .and_return({twilio: {from_number: from_number}})

    stub_const("TWILIO_CLIENT", twilio_client)
    allow(twilio_client).to receive(:messages).and_return(message_list)
  end

  describe ".call" do
    it "sends an SMS and saves the message" do
      allow(message_list).to receive(:create)
        .with(from: from_number, to: valid_phone, body: message)
        .and_return(message_instance)

      expect {
        described_class.call(to: valid_phone, body: message, user: user)
      }.to change(Message, :count).by(1)
    end
  end

  describe "#execute!" do
    subject(:service) { described_class.new(to: valid_phone, body: message, user: user) }

    before do
      allow(message_list).to receive(:create)
        .with(from: from_number, to: valid_phone, body: message)
        .and_return(message_instance)
    end

    it "sends the SMS and saves the message" do
      expect(message_list).to receive(:create)
      expect {
        service.execute!
      }.to change(Message, :count).by(1)
    end

    context "when Twilio fails to send the message" do
      let(:twilio_error_response) do
        double("Twilio::HTTPResponse", status_code: 400, body: {message: "Invalid phone number", code: 21211})
      end

      let(:twilio_error) { Twilio::REST::RestError.new("Invalid phone number", twilio_error_response) }

      before do
        allow(twilio_client).to receive(:messages).and_return(message_list)
        allow(message_list).to receive(:create)
          .with(from: from_number, to: valid_phone, body: message)
          .and_raise(twilio_error)
      end

      it "returns a FailureResult when Twilio fails to send the message" do
        result = service.execute!

        expect(result).to be_a(Result::FailureResult)
        expect(result.success?).to be_falsey
        expect(result.error).to match(/Invalid phone number/)
      end
    end

    context "when the message fails to save" do
      before do
        allow(message_list).to receive(:create).and_return(message_instance)
        allow_any_instance_of(Message).to receive(:save!).and_raise(Mongoid::Errors::Validations.new(Message.new))
      end

      it "raises a validation error" do
        expect {
          service.execute!
        }.to raise_error(Mongoid::Errors::Validations)
      end
    end
  end
end
