RSpec.shared_examples 'password validation' do
  context 'when password is a string with at list 6 items' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:password) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is emtpy string' do
    let(:params) { valid_params.merge(password: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(password: 1234) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when password length is less then 6 items' do
    let(:params) { valid_params.merge(password: '12345') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
