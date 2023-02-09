# frozen_string_literal: true

# Status
class Status < ApplicationRecord
  MEDIA_LIMIT = 4

  belongs_to :user
  has_many :replies, class_name: 'Status', foreign_key: :status_id
  has_many :media

  validates :user_id, presence: true
  validates :body, presence: true, allow_blank: false, length: { maximum: 300 }
  validates :media,
            length: {
              maximum: MEDIA_LIMIT,
              message: 'cannot contain over four media'
            }

  accepts_nested_attributes_for :media,
                                reject_if:
                                  proc { |attributes|
                                    attributes['medium_type'].blank? ||
                                      attributes['url'].blank?
                                  },
                                allow_destroy: true
end
