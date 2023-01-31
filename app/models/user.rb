# frozen_string_literal: true

# User
class User < ApplicationRecord
  validates :handle, presence: true, uniqueness: true, length: { in: 4..12 }, format: { with: /\A[a-zA-z0-9_]*\z/ }
  validates :display_name, presence: true, length: { maximum: 30 }
  validates :bio, length: { maximum: 300 }, allow_blank: true
  validates :born_at, presence: true
  validate :user_must_be_above_min_age

  has_many :followers, foreign_key: :followed_id, class_name: 'Follow'
  has_many :following, foreign_key: :follower_id, class_name: 'Follow'

  private

  MIN_AGE = 13

  def user_must_be_above_min_age
    errors.add(:born_at, 'must be over 13 years old') unless born_at.present? && born_at <= MIN_AGE.years.ago.to_date
  end
end
