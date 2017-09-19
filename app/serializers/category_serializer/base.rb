module CategorySerializer
  class Base < ActiveModel::Serializer
    has_many :applications, serializer: ApplicationSerializer::Short

    attributes :id, :title, :summary, :applications_count
  end
end
