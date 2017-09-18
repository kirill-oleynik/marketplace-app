class AddToFavoritesInteraction
  include Dry::Transaction
  include Inject[
    favorite_repository: 'repositories.favorite',
    application_repository: 'repositories.application'
  ]

  step :check_application_existance
  step :persist

  def check_application_existance(user:, application_id:)
    application_repository.find(application_id)

    Right(user_id: user.id, application_id: application_id)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: application_id, entity: 'application' }])
  end

  def persist(user_id:, application_id:)
    favorite = favorite_repository.create!(
      user_id: user_id,
      application_id: application_id
    )

    Right(favorite)
  rescue ActiveRecord::RecordNotUnique
    Left([:invalid, application_id: [I18n.t('errors.not_unique')]])
  end
end
