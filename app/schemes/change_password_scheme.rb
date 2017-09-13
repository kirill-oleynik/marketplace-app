ChangePasswordScheme = Dry::Validation.Schema do
  required(:user).filled
  required(:current_password).filled(:str?)
  required(:password).filled(:str?, min_size?: 6).confirmation
  required(:client_id).filled
end
