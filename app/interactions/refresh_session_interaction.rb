class RefreshSessionInteraction
  include Dry::Transaction
  include Inject[
    create_auth_credentials: 'commands.create_auth_credentials',
    refresh_session_scheme: 'schemes.refresh_session',
    validate_refresh_token: 'commands.validate_refresh_token'
  ]

  step :validate_params
  step :check_refresh_token
  step :generate_credentials

  def validate_params(input)
    result = refresh_session_scheme.call(input)

    if result.success?
      Right(input)
    else
      Left([:invalid, session: [I18n.t('errors.authentication')]])
    end
  end

  def check_refresh_token(input)
    result = validate_refresh_token.call(input)

    if result.success?
      Right(result.value)
    else
      Left(result.value)
    end
  end

  def generate_credentials(input)
    result = create_auth_credentials.call(input)

    if result.success?
      Right(
        result
          .value.to_h
          .slice('access_token', 'refresh_token', 'client_id')
      )
    else
      Left(result.value)
    end
  end
end
