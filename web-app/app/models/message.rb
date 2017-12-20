class Message < ApplicationRecord

	enum status: [ :new_message, :done, :actual, :hidden, :not_relevant ]

	has_many :images, dependent: :destroy
	belongs_to :category

	geocoded_by :address
	reverse_geocoded_by :latitude, :longitude

	after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
	after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? and obj.longitude.present? and obj.address.nil? }

    paginates_per 1

end
