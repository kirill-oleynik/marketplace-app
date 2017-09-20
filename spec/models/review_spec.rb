require 'rails_helper'

RSpec.describe Review do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:application) }

  describe '#find_value_by_user_and_application', :with_db_cleaner do
    let(:review_value) do
      described_class.find_value_by_user_and_application(
        user: user,
        application: application
      )
    end

    let(:user) { create(:user) }
    let(:application) { create(:application) }
    let(:review_value) { 1 }

    before do
      create(:review, value: review_value, user: user, application: application)
    end

    it 'returns review value created by given user' do
      expect(review_value).to eq(review_value)
    end
  end
end
