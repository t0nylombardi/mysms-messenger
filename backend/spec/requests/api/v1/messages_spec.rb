# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Api::V1::Messages", type: :request do
  let(:user) { create(:user, password: "password123") }
  let(:token) { Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first }
  let(:auth_headers) { {"Authorization" => "Bearer #{token}"} }

  describe "GET /api/v1/messages" do
    it "returns http success" do
      get "/api/v1/messages", headers: auth_headers, as: :json
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /api/v1/messages" do
    it "sends a message and returns success" do
      allow(TWILIO_CLIENT.messages).to receive(:create).and_return(double("Message", sid: "SM123"))

      post "/api/v1/messages",
        headers: auth_headers,
        params: {to: "+15551234567", body: "Hello there!"},
        as: :json

      expect(response).to have_http_status(:ok)
    end
  end
end
