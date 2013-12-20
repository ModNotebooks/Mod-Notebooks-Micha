class PageUploader < BaseUploader

  after :store, :persist_secure_token

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
