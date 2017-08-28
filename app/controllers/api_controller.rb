class ApiController < ActionController::API
  include Responder

  before_action :restore_session

  def restore_session
    result = RestoreSessionInteraction.new.call(request.headers)

    if result.success?
      @current_user = result[:user]
    else
      respond_with(result)
    end
  end
end
