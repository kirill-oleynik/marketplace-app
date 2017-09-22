require 'rails_helper'

RSpec.describe CreateReviewInteraction do
  subject(:result) do
    described_class.new(
      create_review_scheme: create_review_scheme,
      application_repository: application_repository,
      review_repository: review_repository,
      rating_repostitory: rating_repostitory,
      update_rating: update_rating
    ).call(params)
  end

  let(:params) do
    {
      application_id: '1',
      user: build(:user),
      value: '1'
    }
  end

  let(:create_review_scheme) { -> (_) { double(success?: true) } }
  let(:application_repository) { double(exists?: true) }
  let(:rating) { build(:rating) }
  let(:review) { build(:review) }

  let(:review_repository) do
    repository = double('review_repository')

    allow(repository)
      .to receive(:create!)
      .and_return(review)

    repository
  end

  let(:rating_repostitory) do
    repository = double('rating_repostitory')

    allow(repository)
      .to receive(:get_for_application_id)
      .with('1')
      .and_return(rating)

    repository
  end

  let(:update_rating) do
    command = double('update_rating')

    allow(command)
      .to receive(:call)
      .with(rating: rating, review: review)
      .and_return(rating)

    command
  end

  let(:update_rating) { double('update_rating', call: rating) }

  context 'when given params are invalid' do
    let(:create_review_scheme) do
      -> (_) { double(success?: false, errors: 'error') }
    end

    it 'returns left monad with errors' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('error')
    end
  end

  context 'when all params are valid' do
    context 'but application does not exist' do
      let(:application_repository) { double(exists?: false) }

      it 'returns left monad with errors' do
        expect(result).to be_left
        expect(result.value[0]).to eq(:not_found)
        expect(result.value[1]).to eq(entity: 'application', id: '1')
      end
    end
  end

  context 'when all params are valid' do
    it 'returns right monad with review' do
      expect(result).to be_right
      expect(result.value).to eq(review)
    end
  end

  context 'when review already exists' do
    before do
      allow(review_repository)
        .to receive(:create!)
        .and_raise(ActiveRecord::RecordNotUnique)
    end

    it 'returns left monad with errors' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
    end
  end
end
