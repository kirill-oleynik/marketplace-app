class Container
  extend Dry::Container::Mixin

  namespace 'repositories' do
    register('user') { User }
  end

  namespace 'schemes' do
    register('restore_session') { RestoreSessionScheme }
    register('sign_in') { SignInScheme }
    register('sign_up') { SignUpScheme }
  end

  namespace 'adapters' do
    register('bcrypt') { BcryptAdapter.new }
    register('jwt') { JwtAdapter.new }
    register('redis') { RedisAdapter.new }
  end

  namespace 'commands' do
    register('create_auth_credentials') { CreateAuthCredentials.new }
  end
end
