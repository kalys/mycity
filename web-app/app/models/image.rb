# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :message
  mount_uploader :image, ImageUploader
end
