# frozen_string_literal: true

require "rails_helper"

RSpec.describe Message, type: :model do
  subject(:message) { build(:message) }

  describe "fields" do
    it { is_expected.to have_field(:_id).of_type(String) }
    it { is_expected.to have_field(:phone).of_type(String) }
    it { is_expected.to have_field(:body).of_type(String) }
    it { is_expected.to have_field(:session_id).of_type(String) }
    it { is_expected.to have_timestamps }
  end

  describe "validations" do
    let(:user) { create(:user) }
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_length_of(:phone).within(10..15) }

    it "is invalid with a non-numeric or malformed phone number" do
      message.phone = "not-a-phone"
      expect(message).not_to be_valid
      expect(message.errors[:phone]).to include("must be a valid phone number")
    end

    it { is_expected.to validate_length_of(:body).within(1..160) }

    it "is invalid with non-printable characters in body" do
      message.body = "Hello\x00World"
      expect(message).not_to be_valid
      expect(message.errors[:body]).to include("must be printable text only")
    end

    it { is_expected.to validate_presence_of(:session_id) }

    it "is invalid with a malformed session_id" do
      message.session_id = "12345"
      expect(message).not_to be_valid
      expect(message.errors[:session_id]).to include("must be a valid UUID")
    end
  end
end
