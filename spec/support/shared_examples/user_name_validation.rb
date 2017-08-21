RSpec.shared_examples 'user_name validation' do |attribute|
  context 'when value is not given' do
    let(:params) { valid_params.except(attribute) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.merge(attribute => nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(attribute => 1234) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(attribute => '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
