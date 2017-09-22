class CreateReviewInteraction
  include Dry::Transaction
  include Inject[
    create_review_scheme: 'schemes.create_review',
    application_repository: 'repositories.application',
    review_repository: 'repositories.review',
    rating_repostitory: 'repositories.rating',
    update_rating: 'commands.update_rating'
  ]

  step :validate_params
  step :check_application
  step :find_rating
  step :persist
  step :update_application_rating

  def validate_params(params)
    result = create_review_scheme.call(params)

    if result.success?
      Right(params)
    else
      Left([:invalid, result.errors])
    end
  end

  def check_application(params)
    app_exists = application_repository.exists?(params[:application_id])

    if app_exists
      Right(params)
    else
      Left([:not_found, { id: params[:application_id], entity: 'application' }])
    end
  end

  def find_rating(params)
    rating = rating_repostitory.get_for_application_id(params[:application_id])

    Right(params.merge(rating: rating))
  end

  def persist(params)
    review_params = params.slice(:value, :rating, :user)
    review = review_repository.create!(review_params)

    Right(params.merge(review: review))
  rescue ActiveRecord::RecordNotUnique
    Left([:invalid, rating: [I18n.t('errors.not_unique')]])
  end

  def update_application_rating(params)
    update_rating.call(
      rating: params[:rating],
      review: params[:review]
    )

    Right(params[:review])
  end
end
