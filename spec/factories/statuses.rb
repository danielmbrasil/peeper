# frozen_string_literal: true

FactoryBot.define do
  factory :status do
    user { create :user }
    body { Faker::Lorem.paragraph[0..300] }
  end

  trait :reply do
    user { create :user }
    status_id { create :status }
    body { Faker::Lorem.paragraph[0..300] }
  end
end
