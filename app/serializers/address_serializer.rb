class AddressSerializer < ActiveModel::Serializer
  attributes :id, :name, :line_1, :line_2, :city,
    :region, :postal_code, :country

  has_one :addressable, polymorphic: true, embed: :ids, include: true
end
