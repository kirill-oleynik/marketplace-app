module FavoriteSerializer
  class Full < Base
    has_one :application, serializer: ApplicationSerializer::Short
  end
end
