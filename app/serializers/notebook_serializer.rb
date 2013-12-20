class NotebookSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :paper_type,
    :carrier_identifier, :created_at,
    :updated_at, :current_state, :notebook_identifier,
    :pages_count

  has_one :user
end
