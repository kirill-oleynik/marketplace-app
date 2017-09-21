module FavoriteSerializer
  class Base < ActiveModel::Serializer
    attributes :id, :user_id
  end
end
