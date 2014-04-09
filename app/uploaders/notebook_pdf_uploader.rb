class NotebookPDFUploader < BaseUploader
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def extension_white_list
    %w(pdf)
  end

  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, super)
    end
end
