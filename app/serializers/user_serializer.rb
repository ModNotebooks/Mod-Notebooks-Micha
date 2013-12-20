class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :notebooks_count

  def notebooks_count
    object.notebooks.count
  end
end
