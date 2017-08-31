RSpec.shared_examples 'job title validation' do
  context 'when job_title is correct' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when value is missing' do
    let(:params) { valid_params.except(:job_title) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is nil' do
    let(:params) { valid_params.merge(job_title: nil) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is not a string' do
    let(:params) { valid_params.merge(job_title: 1234) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when value is an empty string' do
    let(:params) { valid_params.merge(job_title: '') }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end

  context 'when job_title has more than 30 chars' do
    let(:params) { valid_params.merge(job_title: 'a' * 31) }

    it 'is invalid' do
      expect(subject.success?).to be_falsey
    end
  end
end
