class Rating < ApplicationRecord
  VOTE_FIELDS = {
    1 => :one_points_votes,
    2 => :two_points_votes,
    3 => :three_points_votes,
    4 => :four_points_votes,
    5 => :five_points_votes
  }.freeze

  belongs_to :application

  def self.find_by_application_id(id)
    where(application_id: id).first_or_create!
  end

  def self.increment_rating_vote(rating_id:, vote:)
    where(id: rating_id).update_all(
      "#{VOTE_FIELDS[vote]} = #{VOTE_FIELDS[vote]} + 1"
    )
  end
end
