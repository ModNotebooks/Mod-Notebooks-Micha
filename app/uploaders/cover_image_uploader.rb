class CoverImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  process :store_geometry

  version :small do
    process resize_to_fit: [190,270]
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(png jpg)
  end

  def store_geometry
    if @file
      img = MiniMagick::Image.open(@file.path)
      if model
        model.cover_image_width = img['width']
        model.cover_image_height = img['height']
      end
    end
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, super)
    end
end
