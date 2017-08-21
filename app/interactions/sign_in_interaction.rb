class SignInInteraction
  include Dry::Transaction
  include Inject[
    bcrypt: 'utils.bcrypt',
    create_auth_credentials: 'commands.create_auth_credentials',
    sign_in_scheme: 'schemes.sign_in',
    repository: 'repositories.user'
  ]

  step :validate_params
  step :find_user
  step :check_password
  step :generate_credentials

  def validate_params(input)
    result = sign_in_scheme.call(input)

    if result.success?
      Right(input)
    else
      Left([:invalid, result.errors])
    end
  end

  def find_user(input)
    user = repository.find_by(email: input[:email])

    if user
      Right(input.merge(user: user))
    else
      Left([:unauthorized, authentication: [I18n.t('errors.authentication')]])
    end
  end

  def check_password(input)
    secret_hash = bcrypt.encode_with_salt(
      input[:password],
      input[:user].password_hash
    )

    password_match = ActiveSupport::SecurityUtils.secure_compare(
      input[:user].password_hash,
      secret_hash
    )

    if password_match
      Right(input)
    else
      Left([:unauthorized, authentication: [I18n.t('errors.authentication')]])
    end
  end

  def generate_credentials(input)
    result = create_auth_credentials.call(input).value

    Right(
      access_token: result[:access_token],
      refresh_token: result[:refresh_token],
      client_id: result[:client_id]
    )
  end
end
