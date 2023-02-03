# frozen_string_literal: true

# User
class User < ApplicationRecord
  validates :handle, presence: true, uniqueness: true, length: { in: 4..12 }, format: { with: /\A\w*\z/ }
  validates :display_name, presence: true, length: { maximum: 30 }
  validates :bio, length: { maximum: 300 }, allow_blank: true
  validates :born_at, presence: true
  validate :user_must_be_above_min_age

  has_many :followers, foreign_key: :followed_id, class_name: 'Follow'
  has_many :following, foreign_key: :follower_id, class_name: 'Follow'

  def follow(other_user)
    following.create(followed_id: other_user.id) if user_exists?(other_user) && !already_followed?(other_user)
  end

  private

  MIN_AGE = 13

  def user_must_be_above_min_age
    errors.add(:born_at, 'must be over 13 years old') unless born_at.present? && born_at <= MIN_AGE.years.ago.to_date
  end

  def user_exists?(user)
    return true if User.exists?(user.id)

    errors.add(:following, 'user does not exist')
  end

  def already_followed?(other_user)
    return false unless following.where(followed_id: other_user.id).exists?

    errors.add(:following, 'already followed')
  end
end
