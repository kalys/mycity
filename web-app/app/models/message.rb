class Message < ApplicationRecord

	enum status: [ :for_moderation, :done, :actual, :not_relevant, :hidden ]

	has_many :images, dependent: :destroy
	belongs_to :category

	geocoded_by :address
	reverse_geocoded_by :latitude, :longitude

	after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
	after_validation :reverse_geocode, if: ->(obj){ obj.latitude.present? dand obj.longitude.present? and obj.address.nil? }

    paginates_per 10

end
