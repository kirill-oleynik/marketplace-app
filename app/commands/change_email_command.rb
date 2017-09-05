class ChangeEmailCommand
  include Dry::Transaction
  include Inject[
    bcrypt: 'adapters.bcrypt',
  ]

  step :check_user_password
  step :update_email

  def check_user_password(params)
    password_match = bcrypt.compare(
      secret: params[:password],
      secret_hash: params[:user].password_hash
    )

    if password_match
      Right(params)
    else
      Left([:invalid, password: [I18n.t('errors.authentication')]])
    end
  end

  def update_email(params)
    params[:user].update(email: params[:email])

    Right(params[:user])
  end
end
