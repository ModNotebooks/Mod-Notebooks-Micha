class PageUploader < BaseUploader
  include CarrierWave::MiniMagick

  STORE_DIR = "uploads/page/image"

  version :xlarge do
    process resize_to_fit: [3200,3200]
  end

  version :large, from_version: :xlarge do
    process resize_to_fit: [1600,1600]
  end

  version :medium, from_version: :large do
    process resize_to_fit: [800,800]
  end

  version :small, from_version: :medium do
    process resize_to_fit: [400,400]
  end

  version :thumb, from_version: :small do
    process resize_to_fit: [200,200]
  end

  def store_dir
    STORE_DIR
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(png jpg)
  end
end
