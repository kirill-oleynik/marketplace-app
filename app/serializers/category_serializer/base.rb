module CategorySerializer
  class Base < ActiveModel::Serializer
    has_many :applications, serializer: ApplicationSerializer::Short

    attributes :id, :title, :summary

    attribute :application_categories_count, key: :applications_count
  end
end
