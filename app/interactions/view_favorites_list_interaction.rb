class ViewFavoritesListInteraction
  include Dry::Transaction
  include Inject[
    repository: 'repositories.favorite'
  ]

  step :find

  def find(user)
    favorites = repository.all_for_user(user)

    Right(favorites)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: id, entity: 'category' }])
  end
end
