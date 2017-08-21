require 'rails_helper'

RSpec.describe User do
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
end
