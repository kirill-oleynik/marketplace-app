class GetRecoveryLinkCommand
  def call(user_id:, token:)
    "http://#{ENV['CLIENT_DOMAIN']}/password_recovery/#{user_id}/#{token}"
  end
end
