class SignOutInteraction
  include Dry::Transaction
  include Inject[
    repository: 'repositories.session'
  ]

  step :destroy

  def destroy(user_id:, client_id:)
    repository.delete(user_id: user_id, session_id: client_id)

    Right(:ok)
  end
end
