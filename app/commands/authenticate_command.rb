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

    Right(payload)
  rescue JWT::DecodeError, JWT::ExpiredSignature
    Left([:unauthorized])
  end

  def check_session(data)
    session_exists = session_storage.exists?(
      data['user_id'],
      data['client_id']
    )

    if session_exists
      Right(data)
    else
      Left([:unauthorized])
    end
  end

  def find_user(data)
    user = repository.find(data['user_id'])

    Right([user, data['client_id']])
  rescue ActiveRecord::RecordNotFound
    Left([:unauthorized])
  end
end
