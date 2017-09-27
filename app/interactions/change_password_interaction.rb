class ChangePasswordInteraction
  include Dry::Transaction
  include Inject[
    change_password_scheme: 'schemes.change_password',
    bcrypt: 'adapters.bcrypt',
    repository: 'repositories.user',
    session_repository: 'repositories.session',
    jwt: 'adapters.jwt',
    change_password: 'commands.change_password'
  ]

  step :validate
  step :check_password
  step :persist
  step :delete_other_sessions

  def validate(params)
    result = change_password_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def check_password(params)
    password_match = bcrypt.compare(
      secret: params[:current_password],
      secret_hash: params[:user].password_hash
    )

    if password_match
      Right(params)
    else
      Left([:invalid, current_password: [I18n.t('errors.authentication')]])
    end
  end

  def persist(params)
    persist_params = params.slice(:user, :password)
    params[:user] = change_password.call(persist_params).value

    Right(params)
  end

  def delete_other_sessions(params)
    session_repository.delete_sessions(
      user_id: params[:user].id,
      exclude_sessions_ids: params[:client_id]
    )

    Right(params[:user])
  end
end
