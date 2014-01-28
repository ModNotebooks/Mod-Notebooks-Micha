class PreferencesSerializer < ActiveModel::Serializer
  attributes :id

  has_one :address, embed: :ids, include: true
end
