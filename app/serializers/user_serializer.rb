class UserSerializer < ActiveModel::Serializer
  attributes :email, :api_key
end
