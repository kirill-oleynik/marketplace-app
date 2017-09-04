class Container
  extend Dry::Container::Mixin

  namespace 'repositories' do
    register('user') { User }
    register('profile') { Profile }
  end

  namespace 'schemes' do
    register('sign_in') { SignInScheme }
    register('sign_up') { SignUpScheme }
    register('refresh_session') { RefreshSessionScheme }
    register('change_extra_info') { ChangeExtraInfoScheme }
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
  end
end
