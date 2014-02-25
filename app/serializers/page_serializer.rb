class PageSerializer < ActiveModel::Serializer
  attributes :id, :position, :index, :image, :previous_page, :next_page

  has_one :user, embed: :ids, include: true
  has_one :notebook, embed: :ids, include: true

  def image
    attachment = object.image
    attachment.versions.keys.inject({ original: attachment.url }) do |memo, version|
      memo[version] = attachment.url(version)
      memo
    end
  end

  def previous_page
    object.higher_item.try do |p|
      { id: p.id, index: p.index }
    end
  end

  def next_page
    object.lower_item.try do |p|
      { id: p.id, index: p.index }
    end
  end
end
