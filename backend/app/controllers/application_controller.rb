# frozen_string_literal: true

# This file is part of the application controller for a Ruby on Rails API.
# It inherits from ActionController::API and includes Devise for user authentication.
# The controller is responsible for handling API requests and responses, including
# configuring permitted parameters for user sign up and account updates.

# ApplicationController is the base controller for the application.
# It inherits from ActionController::API to provide a lightweight controller
# suitable for API-only applications.
class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # This method is used to configure the parameters that are permitted for
  # sign up and account update actions in Devise.
  # It allows the :email parameter to be included in the sign up and
  # account update forms.
  #
  # @return [void]
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email])
  end
end
