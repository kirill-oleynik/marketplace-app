require 'rails_helper'

RSpec.describe User do
  it { is_expected.to have_many(:reviews) }
  it { is_expected.to have_many(:application_candidates).dependent(:nullify) }

  describe '#full_name' do
    let(:user) { build(:user, first_name: 'John', last_name: 'Dou') }

    it 'returns user first_name and last_name' do
      expect(user.full_name).to eq('John Dou')
    end
  end

  describe '#find_by_email' do
    let!(:user) { create(:user, email: email) }
    let!(:email) { attributes_for(:user)[:email] }

    it 'returns user with given email', :with_db_cleaner do
      expect(User.find_by_email(email)).to eq(user)
    end
  end

  describe '#favorite_owner?' do
    subject(:user) { build(:user, id: 1) }

    context 'when favorite belongs to user' do
      let(:favorite) { build(:favorite, user_id: 1, application_id: nil) }

      it 'returns true' do
        expect(
          subject.favorite_owner?(favorite)
        ).to be_truthy
      end
    end

    context 'when favorite not belongs to user' do
      let(:favorite) { build(:favorite, user_id: 2, application_id: nil) }

      it 'returns true' do
        expect(
          subject.favorite_owner?(favorite)
        ).to be_falsey
      end
    end
  end
end
