class NotebookPDFUploader < PDFUploader

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
    def secure_token
      var = :"#{mounted_as}_secure_token"
      unless model.try(var).present?
        model.update_attribute(var, super)
      end

      model.try(var)
    end
end
