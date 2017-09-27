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
    register('favorite') { Favorite }
    register('review') { Review }
    register('rating') { Rating }
    register('gallery') { Gallery }
    register('application_candidate') { ApplicationCandidate }
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
    register('create_review') { CreateReviewScheme }
    register('create_application_candidate') do
      CreateApplicationCandidateScheme
    end
    register('password_recovery_initialize') do
      PasswordRecovery::InitializeScheme
    end
  end

  namespace 'adapters' do
    register('bcrypt') { BcryptAdapter.new }
    register('jwt') { JwtAdapter.new }
    register('redis') { RedisAdapter.new }
    register('mailer') { MailerAdapter.new }
  end

  namespace 'commands' do
    register('create_session') { CreateSessionCommand.new }
    register('validate_refresh_token') { ValidateRefreshTokenCommand.new }
    register('authenticate') { AuthenticateCommand.new }
    register('persist_profile') { PersistProfileCommand.new }
    register('change_email') { ChangeEmailCommand.new }
    register('update_rating') { UpdateRatingCommand.new }
    register('get_recovery_link') { GetRecoveryLinkCommand.new }
  end
end
