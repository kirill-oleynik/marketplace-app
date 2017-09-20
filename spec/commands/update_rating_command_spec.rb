require 'rails_helper'

RSpec.describe UpdateRatingCommand do
  subject(:result) do
    described_class.new(
      rating_repository: rating_repository
    ).call(review)
  end

  let(:rating_repository) do
    repository = double('rating_repository')

    allow(repository)
      .to receive(:find_by_application_id)
      .with(review.application_id)
      .and_return(rating)

    allow(repository)
      .to receive(:increment_rating_vote)
      .with(rating_id: 1, vote: 1)
      .and_return(rating)

    repository
  end

  let!(:review) { build(:review, value: 1) }
  let!(:rating) { build(:zero_rating, id: 1) }

  it 'returns rigth monad with udpated rating' do
    expect(result).to be_right
    expect(result.value).to eq(rating)
  end
end
