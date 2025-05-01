# frozen_string_literal: true

class UserSerializer < Blueprinter::Base
  identifier :id

  fields :email, :jti

  association :messages, blueprint: MessageSerializer
end
