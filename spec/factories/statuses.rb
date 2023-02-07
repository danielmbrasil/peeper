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

  trait :with_one_medium do
    media { [create(:medium)] }
  end

  trait :with_four_media do
    media { create_list(:medium, 4) }
  end

  trait :over_media_limit do
    media { create_list(:medium, 5) }
  end
end
