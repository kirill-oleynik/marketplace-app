module CategorySerializer
  class Base < ActiveModel::Serializer
    has_many :applications

    attributes :id, :title, :applications, :applications_count
  end
end
