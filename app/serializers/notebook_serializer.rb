class NotebookSerializer < ActiveModel::Serializer
  attributes :id, :name, :color, :paper_type,
    :carrier_identifier, :meta, :created_at,
    :updated_at, :current_state, :notebook_identifier

  has_one :user
end
