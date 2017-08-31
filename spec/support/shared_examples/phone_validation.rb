RSpec.shared_examples 'phone validation' do
  context 'when phone is correct' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:phone) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is nil' do
    let(:params) { valid_params.merge(phone: nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(phone: []) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(phone: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when phone has invalid format' do
    let(:params) { valid_params.merge(phone: 'invalid') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
