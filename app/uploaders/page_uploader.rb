class PageUploader < BaseUploader
  include CarrierWave::MiniMagick

  after :store, :persist_secure_token

  version :large do
    process resize_to_fit: [1000,1000]
  end

  version :large_2x do
    process resize_to_fit: [2000,2000]
  end

  version :medium do
    process resize_to_fit: [800,800]
  end

  version :medium_2x do
    process resize_to_fit: [1600,1800]
  end

  version :small do
    process resize_to_fit: [400,400]
  end

  version :small_2x do
    process resize_to_fit: [800,800]
  end

  version :thumb do
    process resize_to_fit: [200,200]
  end

  version :thumb_2x do
    process resize_to_fit: [400,400]
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(png)
  end

  protected
    def secure_token
      var = :"#{mounted_as}_secure_token"
      unless model.try(var).present?
        model.send(:"#{var}=", super)
      end

      model.try(var)
    end

    def persist_secure_token(file)
      model.save
    end
end
