SignInScheme = Dry::Validation.Schema do
  required(:email).filled(:str?, :email?)
  required(:password).filled(:str?, min_size?: 6)
end
