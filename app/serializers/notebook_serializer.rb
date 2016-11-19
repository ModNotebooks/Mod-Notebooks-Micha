class NotebookSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :color,
    :paper,
    :carrier_identifier,
    :created_at,
    :updated_at,
    :state,
    :notebook_identifier,
    :handle_method,
    :pages_count,
    :submitted_on,
    :received_on,
    :uploaded_on,
    :processed_on,
    :returned_on,
    :recycled_on,
    :available_on,
    :cover_image,
    :cover_image_retina,
    :pdf_url

  has_one :user, embed: :ids, include: true
  has_many :pages, embed: :ids

  def cover_image
    object.cover_image.try(:url, :small)
  end

  def cover_image_retina
    object.cover_image.try(:url)
  end

  def pdf_url
    if object.pdf_url == nil
      '<div></div>'
    else
      '<a href="' + object.pdf_url + '">Download as PDF</a>'
    end
  end
end
