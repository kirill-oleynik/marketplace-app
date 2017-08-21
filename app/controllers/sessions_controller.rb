class SessionsController < ApiController
  def create
    result = SignInInteraction.new.call(params)
    respond_with(result, status: 200)
  end
end
