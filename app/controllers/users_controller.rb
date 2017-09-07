class UsersController < ApiController
  before_action :authenticate!, only: [:current, :update, :password]

  rescue_from Pundit::NotAuthorizedError, with: unauthorized_response

  def create
    result = SignUpInteraction.new.call(create_params)
    respond_with(result, status: 201, serializer: UserSerializer)
  end

  def update
    authorize User.find(params[:id])
    result = UpdateUserInteraction.new.call(update_params)
    respond_with(result, status: 200, serializer: UserSerializer)
  end

  def current
    render(json: current_user, root: 'data', serializer: UserSerializer)
  end

  def password
    result = ChangePasswordInteraction.new.call(password_params)
    respond_with(result, status: 200, serializer: UserSerializer)
  end

  private

  def create_params
    params.permit(
      :first_name, :last_name, :email, :password, :password_confirmation
    )
  end

  def update_params
    params.permit(
      :id, :first_name, :last_name, :email, :password,
      :phone, :job_title, :organization
    )
  end

  def password_params
    params
      .permit(:current_password, :password, :password_confirmation)
      .merge(user: current_user)
  end
end
