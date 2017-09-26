PasswordRecovery::InitializeScheme = Dry::Validation.Schema do
  required(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
end
