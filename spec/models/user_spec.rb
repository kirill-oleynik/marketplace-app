require 'rails_helper'

RSpec.describe User do
  describe '#full_name' do
    let(:user) { build(:user, first_name: 'John', last_name: 'Dou') }

    it 'returns user first_name and last_name' do
      expect(user.full_name).to eq('John Dou')
    end
  end
end
