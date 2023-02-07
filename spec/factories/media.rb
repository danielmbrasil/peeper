# frozen_string_literal: true

FactoryBot.define do
  factory :medium do
    medium_type { rand(0..1) }
    url { Faker::Internet.url }
    status { create :status }
  end

  trait :float_medium_type do
    medium_type { rand(0.0..1.0) }
  end

  trait :empty_url do
    url { '' }
  end

  trait :invalid_url do
    url { 'not a url' }
  end
end
