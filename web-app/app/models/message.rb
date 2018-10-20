# frozen_string_literal: true

class Message < ApplicationRecord
  enum status: %i[for_moderation done actual not_relevant hidden]

  has_many :images, dependent: :destroy
  belongs_to :category, optional: true

  # geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude

  # after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
  # after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? and obj.longitude.present? and obj.address.nil? }

  paginates_per 10
end
