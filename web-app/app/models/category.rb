# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :messages, dependent: :destroy

  validates :title, presence: true, length: { maximum: 40 }

  paginates_per 10
end
