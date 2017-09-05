class SignInInteraction
  include Dry::Transaction
  include Inject[
    bcrypt: 'adapters.bcrypt',
    sign_in_scheme: 'schemes.sign_in',
    create_session: 'commands.create_session',
    repository: 'repositories.user'
  ]

  step :validate
  step :find_user
  step :check_password
  step :create_new_session

  def validate(params)
    result = sign_in_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def find_user(params)
    user = repository.find_by_email(params[:email])

    if user
      Right(params.merge(user: user))
    else
      Left([:unauthorized])
    end
  end

  def check_password(params)
    password_match = bcrypt.compare(
      secret: params[:password],
      secret_hash: params[:user].password_hash
    )

    if password_match
      Right(params)
    else
      Left([:unauthorized])
    end
  end

  def create_new_session(params)
    session = create_session.call(
      user_id: params[:user].id,
      remember_me: params[:remember_me]
    ).value

    Right(session)
  end
end
