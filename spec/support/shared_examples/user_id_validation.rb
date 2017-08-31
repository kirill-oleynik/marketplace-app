RSpec.shared_examples 'user id validation' do
  context 'when user_id is correct' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:user_id) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is nil' do
    let(:params) { valid_params.merge(user_id: nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not an integer' do
    let(:params) { valid_params.merge(user_id: '1') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(user_id: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
