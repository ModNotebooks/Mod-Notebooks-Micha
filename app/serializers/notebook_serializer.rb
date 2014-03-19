class NotebookSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :color,
    :paper_type,
    :carrier_identifier,
    :created_at,
    :updated_at,
    :state,
    :notebook_identifier,
    :pages_count,
    :submitted_on,
    :received_on,
    :uploaded_on,
    :processed_on,
    :returned_on,
    :recycled_on,
    :available_on

  has_one :user, embed: :ids, include: true
  has_many :pages, embed: :ids
end
