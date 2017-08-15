SignUpScheme = Dry::Validation.Schema do
  required(:first_name).filled(:str?)
  required(:last_name).filled(:str?)
  required(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
  required(:password).filled(:str?, min_size?: 6).confirmation
end
