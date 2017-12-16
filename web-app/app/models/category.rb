class Category < ApplicationRecord
	has_many :messages, dependent: :destroy

	validates :title, presence: true, length: {maximum: 40}


end
