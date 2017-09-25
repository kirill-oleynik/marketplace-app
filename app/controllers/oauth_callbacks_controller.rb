class OauthCallbacksController < ApiController
  def linkedin
    result = SignInWithLinkedinInteraction.new.call(oauth_params)
    redirect_to result.value
  end

  def failure
    redirect_to params[:origin]
  end

  private

  def oauth_response
    request.env['omniauth.auth']
  end

  def oauth_params
    {
      email: oauth_response.info.email,
      first_name: oauth_response.info.first_name,
      last_name: oauth_response.info.last_name
    }
  end
end
