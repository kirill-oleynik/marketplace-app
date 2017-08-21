# rubocop:disable Metrics/BlockLength

RSpec.shared_examples 'email validation' do
  context 'when emails is correct' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:email) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is nil' do
    let(:params) { valid_params.merge(email: nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(email: 1234) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(email: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when email has invalid format' do
    let(:params) { valid_params.merge(email: 'invalid') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
