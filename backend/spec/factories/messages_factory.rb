# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    phone { Faker::PhoneNumber.cell_phone_in_e164 }
    body { Faker::Lorem.sentence }
    session_id { SecureRandom.hex(8) }
  end
end
