ActiveSupport.on_load(:active_model_serializers) do
  # Disable for all serializers (except ArraySerializer)
  ActiveModel::Serializer.root = true

  # Disable for ArraySerializer
  ActiveModel::ArraySerializer.root = true
end
