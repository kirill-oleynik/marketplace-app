class SignInWithLinkedinInteraction
  include Dry::Transaction
  include Inject[
    bcrypt: 'adapters.bcrypt',
    repository: 'repositories.user',
    create_session: 'commands.create_session',
    get_oauth_redirect_url: 'commands.get_oauth_redirect_url'
  ]

  step :ensure_user
  step :create_new_session
  step :build_redirect_url

  def ensure_user(params)
    user = repository.find_by_email(params[:email])
    return Right(user) if user

    user = repository.create!(
      email: params[:email],
      first_name: params[:first_name],
      last_name: params[:last_name],
      password_hash: bcrypt.encode(SecureRandom.urlsafe_base64)
    )

    Right(user)
  end

  def create_new_session(user)
    session = create_session.call(
      user_id: user.id,
      remember_me: true
    ).value

    Right(session)
  end

  def build_redirect_url(session)
    redirect_url = get_oauth_redirect_url.call(
      clientId: session.client_id,
      accessToken: session.access_token,
      refreshToken: session.refresh_token
    )

    Right(redirect_url)
  end
end
