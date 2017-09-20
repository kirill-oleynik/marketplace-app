class GallerySerializer < ActiveModel::Serializer
  attributes :id, :application_id

  has_many :gallery_attachments, key: :slides
end
