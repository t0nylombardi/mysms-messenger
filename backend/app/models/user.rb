# frozen_string_literal: true

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  ## Database authenticatable
  field :email, type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## JWT revocation support
  field :jti, type: String, default: -> { SecureRandom.uuid }
  index({jti: 1}, {unique: true})

  # Associations
  has_many :messages, class_name: "Message", dependent: :destroy

  # Validation
  validates :email, presence: true, uniqueness: true
  validates :jti, presence: true, uniqueness: true

  def self.primary_key
    :id
  end

  def self.revoke_jwt(_payload, user)
    user.set(jti: SecureRandom.uuid)
  end
end
