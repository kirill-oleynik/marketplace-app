CreateApplicationScheme = Dry::Validation.Schema do
  required(:slug).filled(:str?, format?: Application::SLUG_REGEXP)
  required(:title).filled(:str?)
  required(:summary).filled(:str?)
  required(:attachment_id).filled(:int?)
  required(:description).filled(:str?)
  required(:website).filled(:str?)
  required(:email).filled(:str?, format?: URI::MailTo::EMAIL_REGEXP)
  optional(:address).filled(:str?)
  optional(:phone).filled(:str?)
  optional(:founded).filled(:date?)
end
