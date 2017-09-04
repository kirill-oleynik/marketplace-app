RSpec.shared_examples 'client id validation' do
  context 'when value is correct' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:client_id) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is nil' do
    let(:params) { valid_params.merge(client_id: nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(client_id: 123) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(client_id: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
