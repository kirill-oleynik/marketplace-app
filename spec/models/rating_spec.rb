require 'rails_helper'

RSpec.describe Rating do
  it { is_expected.to belong_to(:application) }

  describe '#average_vote' do
    let!(:rating) do
      build(
        :rating,
        one_points_votes: 3,
        two_points_votes: 1,
        three_points_votes: 0,
        four_points_votes: 3,
        five_points_votes: 9
      )
    end

    it 'updates average' do
      expect(rating.average_vote).to eq(3.875)
    end
  end

  describe '#find_by_application_id', :with_db_cleaner do
    let!(:application) { create(:application) }

    context 'when rating exists' do
      let!(:rating) { create(:rating, application_id: application.id) }

      it 'returns existing rating' do
        result = described_class.find_by_application_id(application.id)

        expect(result).to eq(rating)
      end
    end

    context 'when rating does not exist' do
      it 'returns null object' do
        result = described_class.find_by_application_id(application.id)

        expect(result).to be_kind_of(described_class)
      end
    end
  end

  describe '#increment_vote!', :with_db_cleaner do
    let!(:rating) { create(:zero_rating) }

    it 'increments rating due to given vote' do
      expect(rating.one_points_votes).to eq(0)
      described_class.increment_vote!(rating: rating, vote: 1)
      rating.reload
      expect(rating.one_points_votes).to eq(1)
    end
  end

  describe '#total_votes' do
    let(:rating) { build(:zero_rating, one_points_votes: 1) }

    it 'returns sum of all votes' do
      expect(rating.total_votes).to eq(1)
    end
  end
end
