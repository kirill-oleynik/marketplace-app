require 'rails_helper'

RSpec.describe ViewFavoritesListInteraction do
  let(:user) { build(:user) }
  let(:favorite) { build(:favorite) }

  let(:repository) do
    repository_mock do |mock|
      allow(mock).to receive(:all_for_user).with(user).and_return([favorite])
    end
  end

  subject { ViewFavoritesListInteraction.new(repository: repository) }

  describe 'when transaction was successful' do
    it 'is returns right monad with all favorites for user' do
      result = subject.call(user)

      expect(result).to be_right
      expect(result.value).to eq([favorite])
    end
  end
end
