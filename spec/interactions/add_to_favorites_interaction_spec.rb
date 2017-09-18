require 'rails_helper'

RSpec.describe AddToFavoritesInteraction do
  let(:user) { build(:user, id: 1) }
  let(:application_id) { 2 }
  let(:favorite) do
    build(:favorite, user_id: user.id, application_id: application_id)
  end

  let(:favorite_repository) do
    repository_mock do |mock|
      allow(mock).to receive(:create!).with(
        user_id: user.id,
        application_id: application_id
      ).and_return(favorite)
    end
  end

  let(:application_repository) do
    repository_mock do |mock|
      allow(mock).to receive(:find).with(application_id).and_return(true)
    end
  end

  let(:params) do
    {
      user: user,
      application_id: application_id
    }
  end

  subject do
    AddToFavoritesInteraction.new(
      favorite_repository: favorite_repository,
      application_repository: application_repository
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
    context 'when application not exists' do
      let(:application_repository) do
        repository_mock do |mock|
          allow(mock).to receive(:find).with(application_id)
                                       .and_raise(ActiveRecord::RecordNotFound)
        end
      end

      it 'returns left monad with not found error tuple' do
        result = subject.call(params)

        expect(result).to be_left
        expect(result.value.first).to eq(:not_found)
      end
    end

    context 'when favorite already created' do
      let(:favorite_repository) do
        repository_mock do |mock|
          allow(mock).to receive(:create!).with(
            user_id: user.id,
            application_id: application_id
          ).and_raise(ActiveRecord::RecordNotUnique)
        end
      end

      it 'returns left monad with validation error tuple' do
        result = subject.call(params)

        expect(result).to be_left
        expect(result.value.first).to eq(:invalid)
        expect(result.value.last[:application_id]).not_to be_empty
      end
    end
  end
end
