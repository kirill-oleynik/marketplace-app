UpdateUserScheme = Dry::Validation.Schema do
  required(:user).filled
  optional(:first_name).filled(:str?)
  optional(:last_name).filled(:str?)
  optional(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
  optional(:password).filled(:str?)
  optional(:phone).filled(:str?, max_size?: 30, format?: /^\d*$/)
  optional(:job_title).filled(:str?, max_size?: 30)
  optional(:organization).filled(:str?, max_size?: 30)

  rule(password_presence: [:email, :password]) do |email, password|
    email.filled?.then(password.filled?)
  end
end
