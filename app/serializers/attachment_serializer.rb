class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :url, :content_type
end
