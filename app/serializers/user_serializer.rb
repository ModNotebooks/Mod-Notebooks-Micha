class UserSerializer < ActiveModel::Serializer
  attributes :email, :authentication_token, :confirmed_at,
    :last_sign_in_at, :meta
end
