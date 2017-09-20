class RatingSerializer < ActiveModel::Serializer
  attributes :id, :votes
  attribute :total_votes, key: :total
  attribute :average_vote, key: :average

  def votes
    {
      '1' => object.one_points_votes,
      '2' => object.two_points_votes,
      '3' => object.three_points_votes,
      '4' => object.four_points_votes,
      '5' => object.five_points_votes
    }
  end
end
