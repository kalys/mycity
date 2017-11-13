class Category < ApplicationRecord
	has_many :messages, dependent: :destroy
end
