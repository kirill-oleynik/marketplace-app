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

  def total_votes
    votes_values.sum
  end

  def average_vote
    vote_points = votes_values.map.with_index { |e, i| e * (i + 1) }
    filled_votes = vote_points.keep_if(&:positive?)
    return 0 if filled_votes.empty?
    filled_votes.sum.to_f / votes_values.sum
  end

  private

  def votes_values
    [
      one_points_votes,
      two_points_votes,
      three_points_votes,
      four_points_votes,
      five_points_votes
    ]
  end
end
