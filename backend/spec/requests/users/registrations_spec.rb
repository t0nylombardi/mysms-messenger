# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /signup", type: :request do
  let(:valid_params) do
    {
      user: {
        email: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
  end

  let(:invalid_params) do
    {
      user: {
        email: "",                      # Invalid email
        password: "short",
        password_confirmation: "nope"   # Mismatched confirmation
      }
    }
  end

  describe "with valid credentials" do
    it "creates a user and returns a 200 with user data" do
      allow(UserSerializer).to receive(:render_as_json).and_call_original

      post "/signup", params: valid_params, as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      expect(json.dig("status", "message")).to eq("Signed up successfully.")
      expect(json.dig("data", "user", "email")).to eq("test@example.com")
      expect(UserSerializer).to have_received(:render_as_json).once
    end
  end

  describe "with invalid credentials" do
    it "returns a 422 with an error message" do
      post "/signup", params: invalid_params, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)

      expect(json.dig("status", "message")).to match(/couldn't be created/i)
    end
  end
end
