class FavoriteSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :application_id
end
