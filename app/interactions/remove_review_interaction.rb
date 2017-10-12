class RemoveReviewInteraction
  include Dry::Transaction
  include Inject[
    rating_repository: 'repositories.rating',
    review_repository: 'repositories.review'
  ]

  step :find_review
  step :authorize
  step :find_rating
  step :persist

  def find_review(id:, user:)
    review = review_repository.find(id)

    Right(user: user, review: review)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: id, entity: 'review' }])
  end

  def authorize(user:, review:)
    if user.review_owner?(review)
      Right(review: review)
    else
      Left([:forbidden])
    end
  end

  def find_rating(review:)
    rating = rating_repository.find(review.rating_id)

    Right(rating: rating, review: review)
  rescue ActiveRecord::RecordNotFound
    Left([:not_found, { id: id, entity: 'review' }])
  end

  def persist(rating:, review:)
    review_repository.transaction do
      review_repository.destroy!(review)
      rating_repository.decrement_vote!(rating: rating, vote: review.value)
    end

    Right(review)
  end
end
