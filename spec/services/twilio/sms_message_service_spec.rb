# frozen_string_literal: true

require "rails_helper"

RSpec.describe Twilio::SmsMessageService do
  let(:valid_phone) { "+15551234567" }
  let(:body) { "Hello there!" }
  let(:session_id) { SecureRandom.uuid }
  let(:from_number) { "+19998887777" }

  let(:twilio_client) { instance_double(Twilio::REST::Client) }
  let(:messages) { instance_double(Twilio::REST::Api::V2010::AccountContext::MessageList) }
  let(:message_instance) { instance_double(Twilio::REST::Api::V2010::AccountContext::MessageInstance, sid: "SM123") }

  before do
    allow(Rails.application.credentials).to receive(:[])
      .with(Rails.env)
      .and_return(twilio: {from_number: from_number})

    stub_const("TWILIO_CLIENT", twilio_client)
    allow(twilio_client).to receive(:messages).and_return(messages)
  end

  describe ".call" do
    it "sends an SMS and saves the message" do
      expect(messages).to receive(:create)
        .with(from: from_number, to: valid_phone, body: body)
        .and_return(message_instance)

      expect(Message).to receive(:create!)
        .with(phone: valid_phone, body: body, session_id: session_id)

      described_class.call(to: valid_phone, body: body, session_id: session_id)
    end
  end

  describe "#execute!" do
    subject(:service) { described_class.new(to: valid_phone, body: body, session_id: session_id) }

    before do
      allow(messages).to receive(:create)
        .with(from: from_number, to: valid_phone, body: body)
        .and_return(message_instance)
    end

    it "sends the SMS and saves the message" do
      expect(messages).to receive(:create)
      expect(Message).to receive(:create!)
        .with(phone: valid_phone, body: body, session_id: session_id)

      service.execute!
    end

    context "when Twilio fails to send the message" do
      let(:twilio_error_response) do
        instance_double("TwilioHttpResponse").tap do |resp|
          allow(resp).to receive(:status_code).and_return(400)
          allow(resp).to receive(:body).and_return({message: "Invalid phone number", code: 21211})
          allow(resp).to receive(:[]).with(:status_code).and_return(400)
          allow(resp).to receive(:[]).with(:body).and_return({message: "Invalid phone number", code: 21211})
        end
      end

      let(:twilio_error) { Twilio::REST::RestError.new("Invalid phone number", twilio_error_response) }

      before do
        allow(messages).to receive(:create).and_raise(twilio_error)
      end

      it "raises a Twilio error" do
        expect { service.execute! }
          .to raise_error(Twilio::REST::RestError, /Invalid phone number/)
      end
    end

    context "when the message is invalid" do
      let(:invalid_phone) { "invalid_phone" }
      let(:invalid_body) { "A" * 161 }

      it "raises a validation error" do
        allow(messages).to receive(:create).and_return(message_instance)

        expect {
          described_class.call(to: invalid_phone, body: invalid_body, session_id: session_id)
        }.to raise_error(Mongoid::Errors::Validations)
      end
    end
  end
end
