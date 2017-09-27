class RecoveryMailer < ApplicationMailer
  def recovery_email(user:, recovery_link:)
    @user = user
    @recovery_link = recovery_link

    mail(
      to: %("#{user.full_name}" <#{user.email}>),
      subject: I18n.t('mail.recovery.subject')
    )
  end
end
