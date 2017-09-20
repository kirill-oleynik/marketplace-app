class UpdateRatingCommand
  include Dry::Transaction
  include Inject[
    rating_repository: 'repositories.rating'
  ]

  step :find_rating
  step :persist

  def find_rating(review)
    rating = rating_repository.find_by_application_id(review.application_id)

    Right(review: review, rating: rating)
  end

  def persist(data)
    rating = rating_repository.increment_rating_vote(
      rating_id: data[:rating].id,
      vote: data[:review].value
    )

    Right(rating)
  end
end
