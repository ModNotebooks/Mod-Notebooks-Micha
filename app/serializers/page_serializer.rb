class PageSerializer < ActiveModel::Serializer
  attributes :id, :number, :image, :user

  has_one :user

  def image
    attachment = object.image
    attachment.versions.keys.inject({ original: attachment.url }) do |memo, vkey|
      memo[vkey] = attachment.url(vkey)
      memo
    end
  end
end
