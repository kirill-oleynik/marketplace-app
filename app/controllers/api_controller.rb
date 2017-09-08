class ApiController < ActionController::API
  include Dry::Monads::Either::Mixin
  include Responder

  serialization_scope :view_context

  private

  def authenticate!
    respond_with(auth_result) unless authenticated?
  end

  def authenticated?
    current_user.present?
  end

  def current_user
    @current_user ||= auth_result.right? ? auth_result.value : nil
  end

  def auth_result
    @auth_result ||= authenticator.call(auth_token)
  end

  def auth_token
    token, _options = begin
      ActionController::HttpAuthentication::Token.token_and_options(request)
    end

    token
  end

  def authenticator
    @authenticator ||= Container.resolve('commands.authenticate')
  end
end
