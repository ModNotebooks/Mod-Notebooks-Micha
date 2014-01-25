class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at,
    :confirmed_at, :unconfirmed_email, :meta

  has_one :address, embed: :ids, include: true
end
