class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :type, :provider, :uid, :disabled_at,
    :disabled_reason, :created_at, :updated_at

  has_one :user, embed: :ids, include: true
end
