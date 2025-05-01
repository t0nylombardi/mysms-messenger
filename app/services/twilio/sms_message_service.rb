# frozen_string_literal: true

# This service is responsible for sending an SMS via Twilio and
# persisting a record of the message to the database.
#
# Example usage:
#   Twilio::SmsMessageService.call(
#     to: "+15551234567",
#     body: "Hello there!",
#     session_id: session from frontend cookie
#   )

module Twilio
  class SmsMessageService
    # @param to [String] The recipient's phone number in E.164 format (e.g., "+15551234567").
    # @param body [String] The SMS message content (160 characters max).
    # @param session_id [String] The UUID that identifies the user's session.
    def initialize(to:, body:, session_id:)
      @to = to
      @body = body
      @session_id = session_id
      @from = Rails.application.credentials[Rails.env][:twilio][:from_number]
    end

    # Public entrypoint for the service.
    #
    # @param to [String] The recipient's phone number.
    # @param body [String] The SMS message content.
    # @param session_id [String] A UUID for identifying the user/session.
    # @return [void]
    def self.call(to:, body:, session_id:)
      new(to:, body:, session_id:).execute!
    end

    # Executes the service: sends the SMS and saves a local copy.
    #
    # @return [void]
    # @raise [Twilio::REST::RestError] If Twilio fails to send the message.
    def execute!
      send_sms
      save_message
    rescue => error
      Rails.logger.error("Twilio SMS Error: #{error.message}")
      raise
    end

    private

    # @return [String] The recipient's number.
    # @return [String] The message content.
    # @return [String] The sender's (Twilio) number.
    # @return [String] The session ID.
    attr_accessor :to, :body, :from, :session_id

    # Sends the SMS using Twilio's REST API client.
    #
    # @return [Twilio::REST::Api::V2010::AccountContext::MessageInstance]
    def send_sms
      TWILIO_CLIENT.messages.create(from:, to:, body:)
    end

    # Saves the sent message into the `messages` collection.
    #
    # @return [Message] The created Message record.
    def save_message
      Message.create!(phone: to, body:, session_id:)
    end
  end
end
