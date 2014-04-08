class NotebookPDFUploader < CarrierWave::Uploader::Base
  include CarrierWaveDirect::Uploader

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  def extension_white_list
    %w(pdf)
  end
end
