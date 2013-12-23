class ShareableSerializer < ActiveModel::Serializer

  def attributes
    hash = super

    if object.is_a? Notebook
      hash = NotebookSerializer.new(object).serializable_hash
      hash['pages'] = ActiveModel::ArraySerializer.new(object.pages, each_serializer: PageSerializer)
    elsif object.is_a? Page
      hash = PageSerializer.new(object).serializable_hash
    end

    hash
  end

end
