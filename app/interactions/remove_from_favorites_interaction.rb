class RemoveFromFavoritesInteraction
  include Dry::Transaction
  include Inject[
    repository: 'repositories.favorite'
  ]

  step :find
  step :authorize
  step :destroy

  def find(id:, user:)
    favorite = repository.find(id)

    Right(user: user, favorite: favorite)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: id, entity: 'favorite' }])
  end

  def authorize(user:, favorite:)
    if user.favorite_owner?(favorite)
      Right(favorite)
    else
      Left([:forbidden])
    end
  end

  def destroy(favorite)
    repository.destroy!(favorite)

    Right(favorite)
  end
end
