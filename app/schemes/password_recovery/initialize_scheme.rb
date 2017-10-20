PasswordRecovery::InitializeScheme = Dry::Validation.Schema do
  required(:email).filled(:str?, :email?)
end
