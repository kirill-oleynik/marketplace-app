class MailerAdapter
  def password_recovery(**options)
    RecoveryMailer.recovery_email(options).deliver_later
  end
end
