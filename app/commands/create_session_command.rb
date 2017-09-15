class CreateSessionCommand
  ACCESS_TOKEN_LIFETIME = 15.minutes

  REFRESH_TOKEN_LIFETIME = 1.day
  REFRESH_TOKEN_WITH_REMEMBER_ME_LIFETIME = 7.days

  include Dry::Transaction
  include Inject[
    jwt: 'adapters.jwt',
    bcrypt: 'adapters.bcrypt',
    redis: 'adapters.redis',
    session_repository: 'repositories.session'
  ]

  step :generate_refresh_token
  step :generate_client_id
  step :generate_access_token
  step :persist

  def generate_refresh_token(data)
    refresh_token = SecureRandom.urlsafe_base64
    refresh_token_hash = bcrypt.encode(refresh_token)

    Right(data.merge(
      refresh_token: refresh_token,
      refresh_token_hash: refresh_token_hash
    ))
  end

  def generate_client_id(data)
    return Right(data) if data[:client_id]

    client_id = loop do
      attempt = SecureRandom.urlsafe_base64
      break attempt unless redis.exists(attempt)
    end

    Right(data.merge(
      client_id: client_id
    ))
  end

  def generate_access_token(data)
    access_token = jwt.encode(
      client_id: data[:client_id],
      user_id: data[:user_id],
      exp: Time.now.to_i + ACCESS_TOKEN_LIFETIME
    )

    Right(data.merge(
      access_token: access_token
    ))
  end

  def persist(data)
    client_id = data[:client_id]
    remember_me = data.fetch(:remember_me, false)

    lifetime =
      if remember_me
        REFRESH_TOKEN_WITH_REMEMBER_ME_LIFETIME
      else
        REFRESH_TOKEN_LIFETIME
      end

    data_to_store = {
      user_id: data[:user_id],
      remember_me: remember_me,
      refresh_token_hash: data[:refresh_token_hash]
    }

    session_repository.persist(
      session_id: client_id,
      data: data_to_store,
      lifetime: lifetime
    )

    Right(
      Session.new(data)
    )
  end
end
