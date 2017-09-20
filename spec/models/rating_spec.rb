require 'rails_helper'

RSpec.describe Rating do
  it { is_expected.to belong_to(:application) }

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
      it 'creates new rating and returns it' do
        result = described_class.find_by_application_id(application.id)

        expect(result).to be_instance_of(described_class)
        expect(described_class.count).to eq(1)
      end
    end
  end

  describe '#increment_rating_vote', :with_db_cleaner do
    let!(:rating) { create(:zero_rating) }

    it 'increments rating due to given vote' do
      expect(rating.one_points_votes).to eq(0)
      described_class.increment_rating_vote(rating_id: rating.id, vote: 1)
      rating.reload
      expect(rating.one_points_votes).to eq(1)
    end
  end
end
