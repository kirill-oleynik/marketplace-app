module ApplicationSerializer
  class Base < ActiveModel::Serializer
    attributes :id, :title, :slug, :logo, :summary
  end
end
