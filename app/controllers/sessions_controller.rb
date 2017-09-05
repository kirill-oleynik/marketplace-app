class SessionsController < ApiController
  def create
    result = SignInInteraction.new.call(create_params)
    respond_with(result, status: 201, serializer: SessionSerializer)
  end

  def refresh
    result = RefreshSessionInteraction.new.call(refresh_params)
    respond_with(result, status: 200, serializer: SessionSerializer)
  end

  private

  def create_params
    params.permit(:email, :password, :remember_me)
  end

  def refresh_params
    params.permit(:client_id, :refresh_token)
  end
end
