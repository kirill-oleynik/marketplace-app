module CategorySerializer
  class Base < ActiveModel::Serializer
    attributes :id, :title, :applications_count

    has_many :applications
  end
end
