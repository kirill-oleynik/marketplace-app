require 'rails_helper'

RSpec.describe UpdateRatingCommand do
  subject(:result) do
    described_class.new(
      rating_repository: rating_repository
    ).call(rating: rating, review: review)
  end

  let(:rating_repository) do
    repository = double('rating_repository')

    allow(repository)
      .to receive(:increment_vote!)
      .with(rating: rating, vote: 1)
      .and_return(updated_rating)

    repository
  end

  let!(:review) { build(:review, value: 1) }
  let!(:rating) { build(:zero_rating) }
  let(:updated_rating) { build(:zero_rating, one_points_votes: 1) }

  it 'returns rigth monad with udpated rating' do
    expect(result).to be_right
    expect(result.value).to eq(updated_rating)
  end
end
