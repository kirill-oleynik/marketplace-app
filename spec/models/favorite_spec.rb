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
end
