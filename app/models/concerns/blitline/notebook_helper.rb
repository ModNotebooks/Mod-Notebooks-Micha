module Blitline::NotebookHelper
  include ActiveSupport::Concern

  def digest
    Digest::SHA1.hexdigest("#{self.id}-#{created_at}-#{Rails.env}")
  end

  def s3_versioned_url_to_filename(url)
    url[Patterns::BITLINE_FILE_WITHOUT_VERSION]
  end

  def image_identifier_to_page(identifier)
    # Pages returned from bitline start at 0 and the 0th
    # page is the inner cover the notebook so add 1
    identifier.match(Patterns::BITLINE_PDF_PAGE).captures.first.to_i + 1
  end
end
