SignInScheme = Dry::Validation.Schema do
  required(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
  required(:password).filled(:str?, min_size?: 6)
end
