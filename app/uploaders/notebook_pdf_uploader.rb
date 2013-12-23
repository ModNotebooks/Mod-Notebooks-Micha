class NotebookPDFUploader < PDFUploader

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
end
