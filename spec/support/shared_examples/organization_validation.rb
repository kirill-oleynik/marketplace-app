RSpec.shared_examples 'organization validation' do
  context 'when organization is correct' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:organization) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is nil' do
    let(:params) { valid_params.merge(organization: nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(organization: 1234) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(organization: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when organization has more than 30 chars' do
    let(:params) { valid_params.merge(organization: 'a' * 31) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
