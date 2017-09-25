require('rails_helper')

RSpec.describe CreateApplicationCandidateInteraction do
  subject(:result) do
    described_class.new(
      scheme: scheme,
      repository: repository
    ).call(params)
  end

  let(:scheme) do
    scheme = double('create_application_candidate_scheme')
    allow(scheme)
      .to receive(:call)
      .and_return(double(success?: true))

    scheme
  end

  let(:repository) do
    repository = double('application_candidate_repository')
    allow(repository).to receive(:create!).and_return(application_candidate)
    repository
  end

  let(:application_candidate) { build(:application_candidate) }

  let(:params) { attributes_for(:application_candidate) }

  context 'when params are valid' do
    it 'returns Right monad created record' do
      expect(repository).to receive(:create!).with(params)
      expect(result).to be_right
      expect(result.value).to eq(application_candidate)
    end
  end

  context 'when params are invalid' do
    before do
      allow(scheme)
        .to receive(:call)
        .and_return(double(success?: false, errors: 'errors'))
    end

    it 'returns Left monad with errors' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('errors')
    end
  end
end
