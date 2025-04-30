# frozen_string_literal: true

module UUIDAsId
  extend ActiveSupport::Concern

  included do
    field :_id, type: String, default: -> { SecureRandom.uuid }
  end
end

Mongoid::Document.send(:include, UUIDAsId)
