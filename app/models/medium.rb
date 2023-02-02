# frozen_string_literal: true

require 'uri'

# Medium
class Medium < ApplicationRecord
  belongs_to :status

  validates :medium_type, presence: true, numericality: { only_integer: true }
  validates :url, presence: true, allow_blank: false, format: { with: URI::DEFAULT_PARSER.make_regexp }

  before_validation :validate_media_limit

  private

  MEDIA_LIMIT = 4

  def validate_media_limit
    return unless status.present?

    errors.add(:media, 'a status cannot contain over four media') if status.media.size > MEDIA_LIMIT
  end
end
