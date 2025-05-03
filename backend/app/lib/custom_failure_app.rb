# frozen_string_literal: true

# app/lib/custom_failure_app.rb
class CustomFailureApp < Devise::FailureApp
  def respond
    if request.format.json?
      json_api_error_response
    else
      super
    end
  end

  def json_api_error_response
    self.status = 401
    self.content_type = "application/json"
    self.response_body = {
      status: 401,
      message: i18n_message
    }.to_json
  end
end
