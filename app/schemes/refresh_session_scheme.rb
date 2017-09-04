RefreshSessionScheme = Dry::Validation.Schema do
  required(:client_id).filled(:str?)
  required(:refresh_token).filled(:str?)
end
