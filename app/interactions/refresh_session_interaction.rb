class RefreshSessionInteraction
  include Dry::Transaction
  include Inject[
    bcrypt: 'adapters.bcrypt',
    repository: 'repositories.user',
    create_session: 'commands.create_session',
    refresh_session_scheme: 'schemes.refresh_session',
    session_storage: 'repositories.session_storage'
  ]

  step :validate
  step :find_session_data
  step :check_refresh_token
  step :find_user
  step :create_new_session

  def validate(params)
    result = refresh_session_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:unauthorized])
    end
  end

  def find_session_data(params)
    session_data = session_storage.find(params[:client_id])

    if session_data.present?
      Right(params.merge(
        session_data
      ))
    else
      Left([:unauthorized])
    end
  end

  def check_refresh_token(params)
    token_match = bcrypt.compare(
      secret: params[:refresh_token],
      secret_hash: params[:refresh_token_hash]
    )

    if token_match
      Right(params)
    else
      Left([:unauthorized])
    end
  end

  def find_user(params)
    repository.find(params[:user_id])

    Right(params)
  rescue ActiveRecord::RecordNotFound
    Left([:unauthorized])
  end

  def create_new_session(params)
    session = create_session.call(
      user_id: params[:user_id],
      client_id: params[:client_id],
      remember_me: params[:remember_me]
    ).value

    Right(session)
  end
end
