class ValidateRefreshToken
  include Dry::Transaction
  include Inject[
    bcrypt: 'adapters.bcrypt',
    redis: 'adapters.redis',
    repository: 'repositories.user'
  ]

  step :find_session_data
  step :validate_refresh_token
  step :find_user

  def find_session_data(input)
    session_data = redis.get(input['client-id'])

    if session_data
      Right(input.merge(JSON.parse(session_data)))
    else
      Left([:unauthorized, session: [I18n.t('errors.session_expired')]])
    end
  end

  def validate_refresh_token(input)
    encrypted_token = bcrypt.encode_with_salt(
      input['x-auth-token'],
      input['refresh_token']
    )

    if encrypted_token == input['refresh_token']
      Right(input)
    else
      Left([:unauthorized, session: [I18n.t('errors.authentication')]])
    end
  end

  def find_user(input)
    user = repository.find(input[:user_id])

    Right(input.merge(user: user))
  rescue ActiveRecord::RecordNotFound
    Left([:unauthorized, session: [I18n.t('errors.user_not_found')]])
  end
end
