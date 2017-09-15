class UpdateUserInteraction
  include Dry::Transaction
  include Inject[
    change_email: 'commands.change_email',
    update_user_scheme: 'schemes.update_user',
    persist_profile_command: 'commands.persist_profile',
    repository: 'repositories.user'
  ]

  step :validate_user_params
  step :update_user_email
  step :update_user_info
  step :update_profile

  def validate_user_params(params)
    result = update_user_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def update_user_email(params)
    return Right(params) unless params[:email]

    result = change_email.call(params.slice(:email, :password, :user))

    if result.success?
      Right(params.merge(user: result.value))
    else
      Left(result.value)
    end
  end

  def update_user_info(params)
    user_params = params.slice(:first_name, :last_name)
    unless user_params.empty?
      params[:user] = repository.update!(params[:user].id, user_params)
    end

    Right(params)
  end

  def update_profile(params)
    profile_params = params.slice(:phone, :job_title, :organization)
    unless profile_params.empty?
      persist_profile_command.call(
        profile_params.merge(user_id: params[:user].id)
      )
    end

    Right(params[:user])
  end
end
