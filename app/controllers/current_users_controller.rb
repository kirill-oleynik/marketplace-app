class CurrentUsersController < ApiController
  before_action :authenticate!

  def show
    render(json: current_user, root: 'data', serializer: UserSerializer)
  end

  def update
    result = UpdateUserInteraction.new.call(update_params)
    respond_with(result, status: 200, serializer: UserSerializer)
  end

  def password
    result = ChangePasswordInteraction.new.call(password_params)
    respond_with(result, status: 200, serializer: UserSerializer)
  end

  private

  def update_params
    params.permit(
      :first_name, :last_name, :email, :password,
      :phone, :job_title, :organization
    ).merge(user: current_user)
  end

  def password_params
    params
      .permit(:current_password, :password, :password_confirmation)
      .merge(user: current_user, token: auth_token)
  end
end
