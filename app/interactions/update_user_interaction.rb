class UpdateUserInteraction
  include Dry::Transaction
  include Inject[
    update_user_scheme: 'schemes.update_user_scheme',
    update_profile_command: 'commands.update_profile_command',
    user_repository: 'repositories.user'
  ]

  step :validate_user_params
  step :find_user
  step :update_user
  step :update_profile

  def validate_user_params(params)
    result = update_user_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def find_user(params)
    user = user_repository.find(params[:id])

    Right(params.merge(user: user))
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, user: [I18n.t('errors.user_not_found')]])
  end

  def update_user(params)
    user_params = params.slice(:first_name, :last_name, :email)
    params[:user].update(user_params) unless user_params.empty?

    Right(params)
  end

  def update_profile(params)
    profile_params = params.merge(user_id: params[:id])
    update_profile_command.call(profile_params) unless profile_params.empty?

    Right(params[:user])
  end
end
