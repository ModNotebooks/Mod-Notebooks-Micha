class PageSerializer < ActiveModel::Serializer
  attributes :id, :index, :image

  has_one :user, embed: :ids, include: true
  has_one :notebook, embed: :ids, include: true

  def image
    attachment = object.image
    attachment.versions.keys.inject({ original: attachment.url }) do |memo, version|
      memo[version] = attachment.url(version)
      memo
    end
  end
end
