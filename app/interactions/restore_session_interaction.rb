class RestoreSessionInteraction
  include Dry::Transaction
  include Inject[
    jwt: 'adapters.jwt',
    repository: 'repositories.user',
    restore_session_scheme: 'schemes.restore_session'
  ]

  step :validate_headers
  step :parse_token
  step :find_user

  def validate_headers(input)
    result = restore_session_scheme.call(input)

    if result.success?
      Right(input['x-auth-token'])
    else
      Left([:invalid, result.errors])
    end
  end

  def parse_token(token)
    decoded_token = jwt.decode(token)

    Right(decoded_token['user_id'])
  rescue JWT::ExpiredSignature
    Left([:unauthorized, session: [I18n.t('errors.session_expired')]])
  end

  def find_user(user_id)
    user = repository.find(user_id)

    Right(user)
  rescue ActiveRecord::RecordNotFound
    Left([:unauthorized, session: [I18n.t('errors.user_not_found')]])
  end
end
