# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    def create
      head :ok
    end
  end

  describe "#configure_permitted_parameters" do
    before do
      routes.draw { post "create" => "anonymous#create" }

      # Simulate Devise controller context
      allow(controller).to receive(:devise_controller?).and_return(true)

      # Stub the Devise sanitizer
      sanitizer = instance_double(ActionController::Parameters)
      allow(controller).to receive(:devise_parameter_sanitizer).and_return(sanitizer)

      # Allow permit to be called with expected keys
      allow(sanitizer).to receive(:permit)
    end

    it "permits email for sign_up" do
      expect(controller.devise_parameter_sanitizer).to receive(:permit).with(:sign_up, keys: %i[email])
      post :create
    end

    it "permits email for account_update" do
      expect(controller.devise_parameter_sanitizer).to receive(:permit).with(:account_update, keys: %i[email])
      post :create
    end
  end
end
