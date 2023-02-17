# frozen_string_literal: true

# Status
class Status < ApplicationRecord
  MEDIA_LIMIT = 4
  BODY_INDEX_DISPLAY_LENGTH = 150
  TRUNCATED_BODY_TERMINATOR = '...'

  belongs_to :user
  has_many :replies, class_name: 'Status', foreign_key: :parent_id, dependent: :destroy
  has_many :media, dependent: :destroy

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
