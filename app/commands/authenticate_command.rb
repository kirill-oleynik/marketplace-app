class AuthenticateCommand
  include Dry::Monads::Either::Mixin
  include Inject[
    jwt: 'adapters.jwt',
    repository: 'repositories.user'
  ]

  def call(token)
    return Left([:unauthorized]) unless token.present?

    payload, _headers = jwt.decode(token)
    user = repository.find(payload['user_id'])

    Right(user)
  rescue JWT::DecodeError, JWT::ExpiredSignature, ActiveRecord::RecordNotFound
    Left([:unauthorized])
  end
end
