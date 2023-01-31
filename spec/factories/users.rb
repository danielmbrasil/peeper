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

    trait :empty_handle do
      handle { '' }
    end

    trait :empty_display_name do
      display_name { '' }
    end

    trait :display_name_longer_than_30_chars do
      display_name { 'this is a name longer than 30 characters' }
    end

    trait :under_min_age do
      born_at { Faker::Date.birthday(min_age: 1, max_age: 12) }
    end

    trait :empty_bio do
      bio { '' }
    end

    trait :bio_longer_than_300_characters do
      bio { Faker::Lorem.paragraph_by_chars(number: rand(301..500)) }
    end
  end
end
