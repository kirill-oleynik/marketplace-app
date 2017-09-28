class GetRecoveryLinkCommand
  WEB_URL = ENV['WEB_URL'].freeze

  def call(token)
    "#{WEB_URL}/password_recovery/#{token}"
  end
end
