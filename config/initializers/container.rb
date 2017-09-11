class Container
  extend Dry::Container::Mixin

  namespace 'repositories' do
    register('user') { User }
    register('profile') { Profile }
    register('category') { Category }
    register('session_storage') { SessionStorage.new(RedisAdapter.new) }
  end

  namespace 'schemes' do
    register('sign_in') { SignInScheme }
    register('sign_up') { SignUpScheme }
    register('refresh_session') { RefreshSessionScheme }
    register('change_extra_info') { ChangeExtraInfoScheme }
    register('update_user_scheme') { UpdateUserScheme }
    register('change_password_scheme') { ChangePasswordScheme }
  end

  namespace 'adapters' do
    register('bcrypt') { BcryptAdapter.new }
    register('jwt') { JwtAdapter.new }
    register('redis') { RedisAdapter.new }
  end

  namespace 'commands' do
    register('create_session') { CreateSessionCommand.new }
    register('validate_refresh_token') { ValidateRefreshTokenCommand.new }
    register('authenticate') { AuthenticateCommand.new }
    register('persist_profile_command') { PersistProfileCommand.new }
    register('change_email') { ChangeEmailCommand.new }
  end
end
