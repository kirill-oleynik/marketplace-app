RefreshSessionScheme = Dry::Validation.Schema do
  required('x-auth-token').filled(:str?)
  required('client-id').filled(:str?)
end
