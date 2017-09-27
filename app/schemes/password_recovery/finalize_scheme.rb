PasswordRecovery::FinalizeScheme = Dry::Validation.Schema do
  required(:user_id).filled(:str?)
  required(:recovery_token).filled(:str?)
  required(:password).filled(:str?, min_size?: 6).confirmation
end
