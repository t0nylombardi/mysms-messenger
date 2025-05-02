# frozen_string_literal: true

# Handles user session responses for Devise authentication using JSON and JWT.
#
# This controller customizes Devise::SessionsController to return JSON responses
# on login and logout. It uses JWT tokens for authentication and supports Devise JWT.
#
# Example successful login response:
# {
#   status: {
#     code: 200,
#     message: 'Logged in successfully.',
#     data: { user: { id: ..., email: ..., ... } }
#   }
# }
#
# Example logout response:
# {
#   status: 200,
#   message: 'Logged out successfully.'
# }

module Users
  class SessionsController < Devise::SessionsController
    include RackSessionsMock
    respond_to :json

    JWT_SECRET = Rails.application.credentials[Rails.env][:devise_jwt][:secret_key]

    ##
    # Called by Devise when a user signs in successfully.
    #
    # @param current_user [User] The currently authenticated user
    # @param _opts [Hash] Optional Devise options (not used)
    def respond_with(current_user, _opts = {})
      render json: success_response("Logged in successfully.", user_data(current_user)), status: :ok
    end

    ##
    # Called by Devise when a user signs out.
    # Attempts to decode the JWT and locate the user.
    def respond_to_on_destroy
      @current_user = find_user_from_token

      if @current_user
        render json: success_response("Logged out successfully."), status: :ok
      else
        render json: error_response("Couldn't find an active session."), status: :unauthorized
      end
    end

    private

    ##
    # Decodes JWT from Authorization header and fetches the associated user.
    #
    # @return [User, nil] The authenticated user or nil if invalid
    def find_user_from_token
      token = request.headers["Authorization"]&.split(" ")&.last
      return nil unless token

      payload = JWT.decode(token, JWT_SECRET).first
      User.find_by(id: payload["sub"])
    rescue JWT::DecodeError, Mongoid::Errors::DocumentNotFound
      nil
    end

    ##
    # Formats a successful JSON response.
    #
    # @param message [String] Message to return
    # @param data [Hash] Optional data to include
    # @return [Hash]
    def success_response(message, data = {})
      {
        status: {
          code: 200,
          message: message,
          data: data.presence
        }.compact
      }
    end

    ##
    # Formats an error JSON response.
    #
    # @param message [String]
    # @return [Hash]
    def error_response(message)
      {
        status: 401,
        message: message
      }
    end

    ##
    # Serializes user attributes using your existing UserSerializer.
    #
    # @param user [User]
    # @return [Hash] Serialized user attributes
    def user_data(user)
      UserSerializer.render_as_json(user)
    end
  end
end
