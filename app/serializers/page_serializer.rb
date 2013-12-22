class PageSerializer < ActiveModel::Serializer
  attributes :id, :index, :image, :user

  has_one :user

  def image
    attachment = object.image
    attachment.versions.keys.inject({ original: attachment.url }) do |memo, version|
      memo[version] = attachment.url(version)
      memo
    end
  end
end
