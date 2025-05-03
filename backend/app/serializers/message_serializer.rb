# frozen_string_literal: true

class MessageSerializer < Blueprinter::Base
  identifier :id

  fields :phone, :body, :session_id, :created_at
end
