class PasswordRecoveryController < ApiController
  def create
    result = PasswordRecovery::InitializeInteraction.new.call(create_params)
    respond_with(result, status: 202)
  end

  private

  def create_params
    params.permit(:email)
  end
end
