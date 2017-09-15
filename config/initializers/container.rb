class Container
  extend Dry::Container::Mixin

  namespace 'repositories' do
    register('user') { User }
    register('profile') { Profile }
    register('category') { Category }
    register('attachment') { Attachment }
    register('application') { Application }
    register('application_attachment') { ApplicationAttachment }
    register('session') { SessionRepository.new }
  end

  namespace 'schemes' do
    register('sign_in') { SignInScheme }
    register('sign_up') { SignUpScheme }
    register('refresh_session') { RefreshSessionScheme }
    register('change_extra_info') { ChangeExtraInfoScheme }
    register('update_user') { UpdateUserScheme }
    register('change_password') { ChangePasswordScheme }
    register('create_attachment') { CreateAttachmentScheme }
    register('create_application') { CreateApplicationScheme }
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
    register('persist_profile') { PersistProfileCommand.new }
    register('change_email') { ChangeEmailCommand.new }
  end
end
