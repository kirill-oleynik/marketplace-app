CreateApplicationCandidateScheme = Dry::Validation.Schema do
  URL_REGEX = %r(^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w\.-]*)*\/?$)

  optional(:user).filled
  required(:user_first_name).filled(:str?)
  required(:user_last_name).filled(:str?)
  required(:user_email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
  required(:description).filled(:str?)
  required(:url).filled(:str?, format?: URL_REGEX)
end
