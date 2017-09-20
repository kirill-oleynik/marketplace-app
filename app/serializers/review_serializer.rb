class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :value, :application_id, :user_id
end
