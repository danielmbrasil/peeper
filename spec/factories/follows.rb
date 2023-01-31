# frozen_string_literal: true

FactoryBot.define do
  factory :follow do
    follower_id { FactoryBot.create(:user) }
    followed_id { FactoryBot.create(:user) }

    trait :no_follower_id do
      follower_id { nil }
    end

    trait :no_followed_id do
      followed_id { nil }
    end
  end
end
