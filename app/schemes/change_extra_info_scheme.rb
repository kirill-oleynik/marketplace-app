ChangeExtraInfoScheme = Dry::Validation.Schema do
  required(:user_id).filled(:int?)
  required(:phone).filled(:str?, max_size?: 30, format?: /^\d*$/)
  required(:job_title).filled(:str?, max_size?: 30)
  required(:organization).filled(:str?, max_size?: 30)
end
