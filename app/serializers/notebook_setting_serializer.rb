class NotebookSettingSerializer < ActiveModel::Serializer
  attributes :id,
    :name,
    :color_code,
    :color,
    :cover_image

    def cover_image
      attachment = object.cover_image
      attachment.versions.keys.inject({ original: attachment.url }) do |memo, version|
        memo[version] = attachment.url(version)
        memo
      end
    end
end
