class ImageUploader < CarrierWave::Uploader::Base

	include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :small do
    process resize_to_fit: [150, 150]
  end

  version :medium do
    process resize_to_fill: [500, 300]
  end

  version :actual do
    process resize_to_fill: [860, 800]
  end

  def extension_whitelist
    %w(jpg jpeg)
  end

end
