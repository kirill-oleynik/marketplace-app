class AuthenticateCommand
  include Dry::Transaction
  include Inject[
    jwt: 'adapters.jwt',
    session_storage: 'repositories.session_storage',
    repository: 'repositories.user'
  ]

  step :check_token
  step :check_session
  step :find_user

  def check_token(token)
    return Left([:unauthorized]) unless token.present?

    payload, _headers = jwt.decode(token)

    Right(
      token: token,
      payload: payload
    )
  rescue JWT::DecodeError, JWT::ExpiredSignature
    Left([:unauthorized])
  end

  def check_session(data)
    session_exists = session_storage.exists?(
      data[:payload]['user_id'],
      data[:payload]['client_id']
    )

    if session_exists
      Right(data)
    else
      Left([:unauthorized])
    end
  end

  def find_user(data)
    user = repository.find(data[:payload]['user_id'])

    Right(user)
  rescue ActiveRecord::RecordNotFound
    Left([:unauthorized])
  end
end
