require 'rails_helper'

RSpec.describe ViewRatingInteraction do
  subject(:result) do
    described_class.new(
      rating_repository: rating_repository,
      application_repository: application_repository
    ).call(application.slug)
  end

  let(:application_repository) do
    repository = double('application_repository')

    allow(repository)
      .to receive(:find_by_slug!)
      .with(application.slug)
      .and_return(application)

    repository
  end

  let(:rating_repository) do
    repository = double('rating_repository')

    allow(repository)
      .to receive(:find_by_application_id)
      .with(application.id)
      .and_return(rating)

    repository
  end

  let(:application) { build(:application) }
  let(:rating) { build(:rating) }

  context 'when application exists' do
    it 'returns right monad with rating' do
      expect(result).to be_right
      expect(result.value).to eq(rating)
    end
  end

  context 'when' do
    before do
      allow(application_repository)
        .to receive(:find_by_slug!)
        .and_raise(ActiveRecord::RecordNotFound)
    end

    it 'returns left monad with errors' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:not_found)
    end
  end
end
