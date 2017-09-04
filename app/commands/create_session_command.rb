class CreateSessionCommand
  ACCESS_TOKEN_LIFETIME = 15.minutes
  REFRESH_TOKEN_LIFETIME = 24.hours

  include Dry::Transaction
  include Inject[
    jwt: 'adapters.jwt',
    bcrypt: 'adapters.bcrypt',
    redis: 'adapters.redis'
  ]

  step :generate_access_token
  step :generate_refresh_token
  step :generate_client_id
  step :persist

  def generate_access_token(params)
    access_token = jwt.encode(
      user_id: params[:user_id],
      exp: Time.now.to_i + ACCESS_TOKEN_LIFETIME
    )

    Right(params.merge(
      access_token: access_token
    ))
  end

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

  def persist(data)
    client_id = data[:client_id]

    data_to_store = {
      user_id: data[:user_id],
      lifetime: REFRESH_TOKEN_LIFETIME,
      refresh_token_hash: data[:refresh_token_hash]
    }

    redis.hmset(client_id, data_to_store)
    redis.expire(client_id, REFRESH_TOKEN_LIFETIME)

    Right(
      Session.new(data)
    )
  end
end
