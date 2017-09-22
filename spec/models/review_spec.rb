require 'rails_helper'

RSpec.describe Review do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:rating) }

  describe '#find_by_user_and_application', :with_db_cleaner do
    let!(:review) { create(:review, user: user, rating: rating) }

    let(:user) { create(:user) }
    let(:application) { create(:application) }
    let(:rating) { create(:rating, application: application) }

    it 'returns review value created by given user' do
      result = described_class.find_by_user_and_application(
        user: user,
        application: application
      )

      expect(result).to eq(review)
    end
  end
end
