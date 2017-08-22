class CreateAuthCredentials
  ACCESS_TOKEN_EXP = 15 * 60
  REFRESH_TOKEN_EXP = 24 * 3600

  include Dry::Transaction
  include Inject[
    bcrypt: 'adapters.bcrypt',
    jwt: 'adapters.jwt',
    redis: 'adapters.redis'
  ]

  step :refresh_token
  step :client_id
  step :store_session_data
  step :access_token

  def refresh_token(input)
    Right(input.merge(refresh_token: SecureRandom.hex(10)))
  end

  def client_id(input)
    client_id = SecureRandom.hex(10)
    client_id = SecureRandom.hex(10) while redis.exists(client_id)

    Right(input.merge(client_id: client_id))
  end

  def store_session_data(input)
    session_data = {
      refresh_token: bcrypt.encode(input[:refresh_token]),
      user_id: input[:user].id,
      exp: REFRESH_TOKEN_EXP
    }

    redis.set(input[:client_id], session_data)
    redis.expire(input[:client_id], REFRESH_TOKEN_EXP)

    Right(input)
  end

  def access_token(input)
    access_token = jwt.encode(
      user_id: input[:user].id,
      exp: Time.now.to_i + ACCESS_TOKEN_EXP
    )

    Right(input.merge(access_token: access_token))
  end
end
