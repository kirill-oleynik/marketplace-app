class SearchResult < Dry::Struct
  attribute :categories, Types::Strict::Array
  attribute :applications, Types::Strict::Array

  alias read_attribute_for_serialization send
end
