module PasswordRecovery
  class FinalizeInteraction
    include Dry::Transaction
    include Inject[
      validation_scheme: 'schemes.password_recovery_finalize',
      jwt: 'adapters.jwt',
      change_password: 'commands.change_password',
      session_repository: 'repositories.session',
      user_repository: 'repositories.user'
    ]

    step :validate
    step :find_user
    step :check_token
    step :persist
    step :delete_sessions

    def validate(params)
      result = validation_scheme.call(params)

      if result.success?
        Right(params)
      else
        Left([:invalid, result.errors])
      end
    end

    def find_user(params)
      user = user_repository.find(params[:user_id])

      Right(params.merge(user: user))
    rescue ActiveRecord::RecordNotFound
      Left([:unauthorized])
    end

    def check_token(params)
      jwt.decode(params[:recovery_token], params[:user].password_hash)

      Right(params)
    rescue JWT::DecodeError, JWT::ExpiredSignature
      Left([:unauthorized])
    end

    def persist(params)
      user = change_password.call(
        user: params[:user],
        password: params[:password]
      ).value

      Right(user)
    end

    def delete_sessions(user)
      session_repository.delete_sessions(user_id: user.id)

      Right(user)
    end
  end
end