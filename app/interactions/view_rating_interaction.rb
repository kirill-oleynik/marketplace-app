class ViewRatingInteraction
  include Dry::Transaction
  include Inject[
    rating_repository: 'repositories.rating',
    application_repository: 'repositories.application'
  ]

  step :find_application
  step :find_rating

  def find_application(application_slug)
    application = application_repository.find_by_slug!(application_slug)

    Right(application.id)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: application_slug, entity: 'application' }])
  end

  def find_rating(application_id)
    rating = rating_repository.find_by_application_id(application_id)

    Right(rating)
  end
end
