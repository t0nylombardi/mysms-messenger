# frozen_string_literal: true

class UserSerializer < Blueprinter::Base
  identifier :id

  fields :email, :jti

  view :minimal do
    fields :id, :email # or whatever is safe
  end
end
