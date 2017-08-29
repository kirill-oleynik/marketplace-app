RestoreSessionScheme = Dry::Validation.Schema do
  required('x-auth-token').filled(:str?)
end
