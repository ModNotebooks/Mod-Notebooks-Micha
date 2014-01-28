class PreferencesSerializer < ActiveModel::Serializer
  attributes :id

  has_one :address
end
