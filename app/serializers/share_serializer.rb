class ShareSerializer < ActiveModel::Serializer
  attributes :id, :token, :url

  has_one :shareable, polymorphic: true, serializer: ShareableSerializer

  def url
    share_url(token: object.token)
  end
end
