class CreateReviewInteraction
  include Dry::Transaction
  include Inject[
    create_review_scheme: 'schemes.create_review',
    application_repository: 'repositories.application',
    review_repository: 'repositories.review'
  ]

  step :validate_params
  step :check_application
  step :persist

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

  def persist(params)
    review_params = params.slice(:value, :application_id, :user)
    review = review_repository.create!(review_params)

    Right(review)
  rescue ActiveRecord::RecordNotUnique
    Left([:invalid, rating: [I18n.t('errors.not_unique')]])
  end
end
