class SignUpInteraction
  include Dry::Transaction
  include Inject[
    scheme: 'schemes.sign_up',
    bcrypt: 'utils.bcrypt',
    repository: 'repositories.user'
  ]

  step :validate
  step :hash_password
  step :persist

  def validate(params)
    result = scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def hash_password(params)
    password_hash = bcrypt.encode(params[:password])

    Right(
      params.merge(password_hash: password_hash)
    )
  end

  def persist(params)
    user = repository.create!(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password_hash: params[:password_hash]
    )

    Right(user)
  rescue ActiveRecord::RecordNotUnique
    Left([:invalid, email: [I18n.t('errors.not_unique')]])
  end
end
