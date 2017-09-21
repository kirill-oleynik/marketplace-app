require 'rails_helper'

RSpec.describe Favorite, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:application) }

  describe '.find_by_user_and_application', :with_db_cleaner do
    let(:user) { create(:user) }
    let(:application) { create(:application) }

    context 'when favorite exists' do
      let!(:favorite) do
        create(:favorite, user: user, application: application)
      end

      it 'returns favorite' do
        result = Favorite.find_by_user_and_application(
          user: user,
          application: application
        )

        expect(result).to eq(favorite)
      end
    end

    context 'when favorite not exists' do
      it 'returns nil' do
        result = Favorite.find_by_user_and_application(
          user: user,
          application: application
        )

        expect(result).to be_nil
      end
    end
  end

  describe '.all_for_user', :with_db_cleaner do
    let(:user) { create(:user) }

    let!(:first_favorite) do
      create(:favorite, user: user, created_at: 1.day.ago)
    end
    let!(:second_favorite) { create(:favorite, user: user) }
    let!(:third_favorite) { create(:favorite) }

    it 'returns favorites for user, ordered by created at' do
      expect(
        Favorite.all_for_user(user)
      ).to eq([second_favorite, first_favorite])
    end
  end
end
