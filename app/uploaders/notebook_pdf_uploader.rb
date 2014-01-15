class NotebookPDFUploader < PDFUploader

  after :store, :persist_secure_token

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, super)
    end
end
