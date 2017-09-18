require 'rails_helper'

RSpec.describe RemoveFromFavoritesInteraction do
  let(:user) { build(:user, id: 1) }
  let(:favorite_id) { 2 }
  let(:favorite) do
    build(:favorite, id: favorite_id, user_id: user.id, application_id: nil)
  end

  let(:favorite_repository) do
    repository_mock do |mock|
      allow(mock).to receive(:find).with(favorite_id).and_return(favorite)
      allow(mock).to receive(:destroy!).with(favorite).and_return(favorite)
    end
  end

  let(:params) do
    {
      user: user,
      id: favorite_id
    }
  end

  subject do
    RemoveFromFavoritesInteraction.new(
      repository: favorite_repository
    )
  end

  describe 'transaction was successful' do
    it 'returns right monad with favorite' do
      result = subject.call(params)

      expect(result).to be_right
      expect(result.value).to eq(favorite)
    end
  end

  describe 'transaction was not successful' do
    context 'when favorite not exists' do
      let(:favorite_repository) do
        repository_mock do |mock|
          allow(mock).to receive(:find).with(favorite_id)
                                       .and_raise(ActiveRecord::RecordNotFound)
        end
      end

      it 'returns left monad with not found error tuple' do
        result = subject.call(params)

        expect(result).to be_left
        expect(result.value.first).to eq(:not_found)
      end
    end

    context 'when favorite belongs to another user' do
      let(:favorite) do
        build(
          :favorite, id: favorite_id, user_id: user.id + 1, application_id: nil
        )
      end

      it 'returns left monad with validation error tuple' do
        result = subject.call(params)

        expect(result).to be_left
        expect(result.value.first).to eq(:forbidden)
      end
    end
  end
end
