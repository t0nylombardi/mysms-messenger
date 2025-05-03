# frozen_string_literal: true

module Twilio
  class SmsMessageService
    def initialize(to:, body:, user:)
      @to = to
      @body = body
      @user = user
      @from = Rails.application.credentials[Rails.env][:twilio][:from_number]
    end

    def self.call(to:, body:, user:)
      new(to:, body:, user:).execute!
    end

    def execute!
      return Result::FailureResult.new("Missing required parameters") unless valid?

      send_result = send_sms
      return send_result unless send_result.success?

      save_result = save_message
      save_result if save_result.success?
    end

    private

    attr_reader :to, :body, :from, :user

    def valid?
      to.present? && body.present? && user.present?
    end

    def send_sms
      TWILIO_CLIENT.messages.create(from:, to:, body:)
      Result::SuccessResult.new("SMS sent")
    rescue Twilio::REST::RestError => error
      # I would call an error tracking service here, like Sentry
      # ErrorHandler.call("Twilio SMS sending failed", error.message)
      Result::FailureResult.new("Failed to send SMS: #{error.message}")
    end

    def save_message
      message = user.messages.create!(phone: to, body: body, session_id: user.id)

      Result::FailureResult.new(message.errors.full_messages.to_sentence) if message.errors.any?
      Result::SuccessResult.new(message)
    end
  end
end
