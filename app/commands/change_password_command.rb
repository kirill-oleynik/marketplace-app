class ChangePasswordCommand
  include Dry::Transaction
  include Inject[
    user_repository: 'repositories.user',
    bcrypt: 'adapters.bcrypt'
  ]

  step :hash_password
  step :udpate

  def hash_password(params)
    password_hash = bcrypt.encode(params[:password])

    Right(params.merge(password_hash: password_hash))
  end

  def udpate(params)
    user = user_repository.update!(
      params[:user].id,
      password_hash: params[:password_hash]
    )

    Right(user)
  end
end
