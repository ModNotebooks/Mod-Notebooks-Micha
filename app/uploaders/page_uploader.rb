class PageUploader < BaseUploader
  include CarrierWave::MiniMagick
  include CarrierWave::ImageOptimizer

  after :store, :persist_secure_token

  version :xlarge do
    process resize_to_fit: [3200,3200]
    process :optimize
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


  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(png jpg)
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
