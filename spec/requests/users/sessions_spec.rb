# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Sessions", type: :request do
  let(:user) { create(:user, password: "password123") }

  describe "POST /login" do
    context "with valid credentials" do
      let(:login_params) do
        {
          user: {
            email: user.email,
            password: "password123"
          }
        }
      end

      it "returns 200 and a JWT in the Authorization header" do
        allow(UserSerializer).to receive(:render_as_json).and_call_original

        post "/login", params: login_params, as: :json

        expect(response).to have_http_status(:ok)
        expect(response.headers["Authorization"]).to be_present

        json = JSON.parse(response.body)
        expect(json.dig("status", "message")).to eq("Logged in successfully.")
        expect(json.dig("status", "data", "email")).to eq(user.email)
        expect(UserSerializer).to have_received(:render_as_json).once
      end
    end

    context "with invalid credentials" do
      it "returns 401 unauthorized" do
        post "/login", params: {
          user: {email: user.email, password: "wrongpassword"}
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /logout" do
    context "with a valid JWT" do
      let(:token) do
        post "/login", params: {
          user: {email: user.email, password: "password123"}
        }, as: :json

        response.headers["Authorization"]
      end

      it "logs out the user" do
        delete "/logout", headers: {"Authorization" => token}, as: :json

        expect(response).to have_http_status(:ok)
        resp = JSON.parse(response.body)["status"].with_indifferent_access

        expect(resp[:code]).to eq(200)
        expect(resp[:message]).to eq("Logged out successfully.")
      end
    end
  end
end
