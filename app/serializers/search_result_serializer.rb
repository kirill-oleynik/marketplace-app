class SearchResultSerializer < ActiveModel::Serializer
  has_many :categories, serializer: CategorySerializer::Short
  has_many :applications, serializer: ApplicationSerializer::Short
end
