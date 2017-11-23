class Message < ApplicationRecord

	enum status: [ :new_message, :done, :actual, :hidden, :not_relevant ]

	has_many :images, dependent: :destroy
	belongs_to :category

	geocoded_by :address
	reverse_geocoded_by :latitude, :longitude

	after_validation :geocode
end
