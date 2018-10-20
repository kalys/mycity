# frozen_string_literal: true

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url
    '/images/' + [version_name, 'default.jpg'].compact.join('_')
  end

  version :medium do
    process resize_to_fill: [500, 300]
  end

  version :actual do
    process resize_to_fill: [860, 800]
  end

  def extension_whitelist
    %w[jpg jpeg]
  end
end
