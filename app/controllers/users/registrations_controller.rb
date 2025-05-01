# frozen_string_literal: true

# Handles user registration via Devise, returning JSON API responses.
#
# This controller customizes Devise::RegistrationsController to respond with JSON
# and uses a serializer to return user information after registration.
#
# Example success response:
# {
#   status: {
#     code: 200,
#     message: "Signed up successfully."
#   },
#   data: {
#     user: { id: ..., email: ..., ... }
#   }
# }
#
# Example failure response:
# {
#   status: {
#     code: 422,
#     message: "User couldn't be created successfully. Email has already been taken"
#   }
# }

module Users
  class RegistrationsController < Devise::RegistrationsController
    include RackSessionsMock
    respond_to :json

    ##
    # Called when Devise attempts to return a response after user registration.
    #
    # @param current_user [User] The newly registered user
    # @param _opts [Hash] Unused Devise options
    def respond_with(current_user, _opts = {})
      if resource.persisted?
        render json: success_response("Signed up successfully.", user_data(current_user)), status: :ok
      else
        render json: error_response("User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"),
          status: :unprocessable_entity
      end
    end

    private

    ##
    # Serializes the given user using your application's serializer.
    #
    # @param user [User]
    # @return [Hash] Serialized user attributes
    def user_data(user)
      {
        user: UserSerializer.render_as_json(user)
      }
    end

    ##
    # Builds a success response JSON payload.
    #
    # @param message [String] Success message
    # @param data [Hash] Serialized user data
    # @return [Hash]
    def success_response(message, data = {})
      {
        status: {
          code: 200,
          message: message
        },
        data: data
      }
    end

    ##
    # Builds an error response JSON payload.
    #
    # @param message [String] Error message
    # @return [Hash]
    def error_response(message)
      {
        status: {
          code: 422,
          message: message
        }
      }
    end
  end
end
