module PasswordRecovery
  class InitializeInteraction
    RECOVERY_TOKEN_LIFETIME = 1.hours.to_i

    include Dry::Transaction
    include Inject[
      user_repository: 'repositories.user',
      validation_scheme: 'schemes.password_recovery_initialize',
      jwt: 'adapters.jwt',
      mailer: 'adapters.mailer',
      get_recovery_link: 'commands.get_recovery_link'
    ]

    step :validate
    step :find_user
    step :generate_recovery_token
    step :generate_recovery_url
    step :send_email

    def validate(params)
      result = validation_scheme.call(params)

      if result.success?
        Right(params)
      else
        Left([:invalid, result.errors])
      end
    end

    def find_user(params)
      user = user_repository.find_by_email!(params[:email])

      Right(user)
    rescue ActiveRecord::RecordNotFound
      Left([:invalid, email: [I18n.t('errors.invalid_user_email')]])
    end

    def generate_recovery_token(user)
      recovery_token = jwt.encode({
        user_id: user.id,
        exp: Time.now.to_i + RECOVERY_TOKEN_LIFETIME
      }, user.password_hash)

      Right(user: user, recovery_token: recovery_token)
    end

    def generate_recovery_url(data)
      recovery_link = get_recovery_link.call(
        user_id: data[:user].id,
        token: data[:recovery_token]
      )

      Right(data.merge(recovery_link: recovery_link))
    end

    def send_email(data)
      mailer.password_recovery(
        user: data[:user],
        recovery_link: data[:recovery_link]
      )

      Right(email: data[:user].email)
    end
  end
end
