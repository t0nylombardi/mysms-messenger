# frozen_string_literal: true

class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :_id, type: String, default: -> { SecureRandom.uuid }

  field :phone, type: String
  field :body, type: String
  field :session_id, type: String

  validates :phone, presence: true
  validates :phone, format: { with: /\A\+?[0-9\s\-()]+\z/, message: "must be a valid phone number" }
  validates :phone, length: { minimum: 10, maximum: 15 }
  validates :body, length: { minimum: 1, maximum: 160 }
  validates :body, format: { with: /\A[\p{Print}\p{Space}]+\z/, message: "must be printable text only" }
  validates :session_id, presence: true
  validates :session_id, format: { with: /\A[0-9a-fA-F\-]{36}\z/, message: "must be a valid UUID" }
  validates :session_id, uniqueness: true
end
