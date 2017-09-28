class GetOauthRedirectUrlCommand
  WEB_URL = ENV['WEB_URL'].freeze

  def call(**params)
    "#{WEB_URL}/oauth/callback?#{params.to_query}"
  end
end
