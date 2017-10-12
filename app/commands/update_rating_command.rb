class UpdateRatingCommand
  include Dry::Transaction
  include Inject[
    rating_repository: 'repositories.rating'
  ]

  def call(rating:, review:)
    rating = rating_repository.increment_vote!(
      rating: rating,
      vote: review.value
    )

    Right(rating)
  end
end
