require 'rails_helper'

RSpec.describe ChangeExtraInfoScheme do
  let(:subject) { UpdateUserScheme.call(params) }
  let(:valid_params) do
    attributes_for(:user).merge(attributes_for(:profile)).merge(id: '1')
  end

  describe 'when all params valid' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  describe 'id' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:id) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'first_name' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:first_name) }

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when value has invalid format' do
      let(:params) { valid_params.merge(first_name: 1234) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'last_name' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:last_name) }

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when value has invalid format' do
      let(:params) { valid_params.merge(last_name: 1234) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'email' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:email) }

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when value has invalid format' do
      let(:params) { valid_params.merge(email: 1234) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'phone' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:phone) }

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when value has invalid format' do
      let(:params) { valid_params.merge(phone: 'phone') }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'job_title' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:job_title) }

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when value has invalid format' do
      let(:params) { valid_params.merge(job_title: 1234) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'organization' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:organization) }

      it 'is valid' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when value has invalid format' do
      let(:params) { valid_params.merge(organization: 1234) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end
end
