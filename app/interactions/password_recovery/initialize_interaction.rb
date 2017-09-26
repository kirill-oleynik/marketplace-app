module PasswordRecovery
  class InitializeInteraction
    RECOVERY_TOKEN_LIFETIME = 1.hours.to_i

    include Dry::Transaction
    include Inject[
      user_repository: 'repositories.user',
      validation_scheme: 'schemes.password_recovery_initialize',
      jwt: 'adapters.jwt'
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
      Left([:not_found, { id: params[:email], entity: 'user' }])
    end

    def generate_recovery_token(user)
      recovery_token = jwt.encode({
        user_id: user.id,
        exp: Time.now.to_i + RECOVERY_TOKEN_LIFETIME
      }, user.password_hash)

      Right(user: user, recovery_token: recovery_token)
    end

    def generate_recovery_url(data)
      recovery_url = "password_recovery/#{data[:recovery_token]}"

      Right(data.merge(recovery_url: recovery_url))
    end

    def send_email(data)
      Right(email: data[:user].email)
    end
  end
end
