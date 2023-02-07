# frozen_string_literal: true

# Status
class Status < ApplicationRecord
  belongs_to :user
  has_many :replies, class_name: 'Status', foreign_key: :status_id
  has_many :media

  validates :user_id, presence: true
  validates :body, presence: true, allow_blank: false, length: { maximum: 300 }
  validates :media, length: { maximum: 4, message: 'cannot contain over four media' }
end
