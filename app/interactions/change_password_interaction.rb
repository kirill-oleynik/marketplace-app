class ChangePasswordInteraction
  include Dry::Transaction
  include Inject[
    change_password_scheme: 'schemes.change_password_scheme',
    bcrypt: 'adapters.bcrypt'
  ]

  step :validate
  step :check_password
  step :hash_password
  step :udpate_user

  def validate(params)
    result = change_password_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def check_password(params)
    password_match = bcrypt.compare(
      secret: params[:current_password],
      secret_hash: params[:user].password_hash
    )

    if password_match
      Right(params)
    else
      Left([:invalid, current_password: [I18n.t('errors.authentication')]])
    end
  end

  def hash_password(params)
    password_hash = bcrypt.encode(params[:password])

    Right(params.merge(password_hash: password_hash))
  end

  def udpate_user(params)
    params[:user].update(password_hash: params[:password_hash])

    Right(params[:user])
  end
end
