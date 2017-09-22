class Review < ApplicationRecord
  REVIEW_SCALE = (1..5).to_a.freeze

  belongs_to :user
  belongs_to :rating

  def self.find_by_user_and_application(application:, user:)
    includes(rating: :application)
      .where(ratings: { application: application }, user: user)
      .first
  end
end
