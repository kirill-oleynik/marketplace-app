class UsersController < ApiController
  before_action :authenticate!, only: [:current]

  def create
    result = SignUpInteraction.new.call(create_params)
    respond_with(result, status: 201, serializer: UserSerializer)
  end

  def update
    result = UpdateUserInteraction.new.call(update_params)
    respond_with(result, status: 200, serializer: UserSerializer)
  end

  def current
    render(json: current_user, root: 'data', serializer: UserSerializer)
  end

  private

  def create_params
    params.permit(
      :first_name, :last_name, :email, :password, :password_confirmation
    )
  end

  def update_params
    params.permit(
      :id, :first_name, :last_name, :email, :phone, :job_title, :organization
    )
  end
end
