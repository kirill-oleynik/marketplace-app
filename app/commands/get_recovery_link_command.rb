class GetRecoveryLinkCommand
  WEB_URL = ENV['WEB_URL'].freeze

  def call(user_id:, token:)
    "#{WEB_URL}/password_recovery/#{user_id}/#{token}"
  end
end
