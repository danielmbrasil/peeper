# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    handle { Faker::Internet.unique.username(specifier: 4..12, separators: ['_']) }
    display_name { Faker::Name.name[1..30] }
    bio { Faker::Lorem.paragraph[0..300] }
    born_at { Faker::Date.birthday(min_age: 13) }

    trait :invalid_handle do
      handle { 'inv@l1d' }
    end

    trait :under_min_age do
      born_at { Faker::Date.birthday(min_age: 1, max_age: 12) }
    end

    trait :empty_bio do
      bio { '' }
    end
  end
end
