# frozen_string_literal: true

class MessageSerializer < Blueprinter::Base
  identifier :id

  fields :phone, :body, :created_at

  association :user, blueprint: UserSerializer, view: :minimal
end
