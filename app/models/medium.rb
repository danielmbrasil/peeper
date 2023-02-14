# frozen_string_literal: true

require 'uri'

# Medium
class Medium < ApplicationRecord
  belongs_to :status

  validates :medium_type, presence: true, numericality: { only_integer: true }
  validates :url, presence: true, allow_blank: false, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
