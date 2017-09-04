class SessionSerializer < ActiveModel::Serializer
  attributes :client_id, :access_token, :refresh_token
end
