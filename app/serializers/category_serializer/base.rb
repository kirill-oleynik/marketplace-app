module CategorySerializer
  class Base < ActiveModel::Serializer
    attributes :id, :title, :summary, :applications_count

    has_many :applications, serializer: ApplicationSerializer::Short
  end
end
