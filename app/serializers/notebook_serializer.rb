class NotebookSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :color,
    :paper_type,
    :carrier_identifier,
    :created_at,
    :updated_at,
    :current_state,
    :current_state_at,
    :current_process_state,
    :current_process_state_at,
    :notebook_identifier,
    :pages_count

  has_one :user, embed: :ids, include: true
  has_many :pages, embed: :ids
end
