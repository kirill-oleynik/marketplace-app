class SessionsController < ApiController
  skip_before_action :restore_session

  def create
    result = SignInInteraction.new.call(params)
    respond_with(result, status: 200)
  end

  def update
    result = RefreshSessionInteraction.new.call(request.headers)
    respond_with(result, status: 200)
  end
end
