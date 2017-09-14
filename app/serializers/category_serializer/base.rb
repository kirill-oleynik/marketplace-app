module CategorySerializer
  class Base < ActiveModel::Serializer
    has_many :applications

    attributes :id, :title, :applications
  end
end
