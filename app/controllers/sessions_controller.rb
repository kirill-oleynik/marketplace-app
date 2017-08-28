class SessionsController < ApiController
  skip_before_action :restore_session

  def create
    result = SignInInteraction.new.call(params)
    respond_with(result, status: 200)
  end
end
