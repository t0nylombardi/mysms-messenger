# frozen_string_literal: true

# This file is used to configure the Twilio client for sending SMS messages.
# It initializes the Twilio client with the account SID and auth token
# stored in environment variables. The client is then made available
# globally as TWILIO_CLIENT.

# Configure Twilio client with account SID and auth token from environment variables
# Ensure you have set these environment variables in your application
# or use a gem like dotenv to manage them.
Twilio.configure do |config|
  config.account_sid = Rails.application.credentials[Rails.env].twilio[:account_sid]
  config.auth_token = Rails.application.credentials[Rails.env].twilio[:auth_token]
end

TWILIO_CLIENT = Twilio::REST::Client.new
