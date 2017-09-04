class Session < Dry::Struct
  attribute :client_id, Types::Strict::String
  attribute :access_token, Types::Strict::String
  attribute :refresh_token, Types::Strict::String

  alias read_attribute_for_serialization send
end
