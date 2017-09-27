class PasswordRecoveryController < ApiController
  def create
    result = PasswordRecovery::InitializeInteraction.new.call(create_params)
    respond_with(result, status: 202)
  end

  def update
    result = PasswordRecovery::FinalizeInteraction.new.call(update_params)
    respond_with(result, status: 201, serializer: UserSerializer)
  end

  private

  def create_params
    params.permit(:email)
  end

  def update_params
    params.permit(:user_id, :recovery_token, :password, :password_confirmation)
  end
end
