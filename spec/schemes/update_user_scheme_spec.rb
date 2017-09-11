require 'rails_helper'

RSpec.describe ChangeExtraInfoScheme do
  let(:subject) { UpdateUserScheme.call(params) }
  let(:user) { attributes_for(:user) }
  let(:valid_params) do
    attributes_for(:user)
      .merge(attributes_for(:profile))
      .merge(user: user, password: 'password')
  end

  describe 'when all params valid' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  describe 'user' do
    context 'when value is missing' do
      let(:params) { valid_params.except(:user) }

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

  describe 'password' do
    context 'when email is not provided' do
      let(:params_without_email) { valid_params.except(:email) }

      context 'and password is not provided' do
        let(:params) { params_without_email.except(:password) }

        it 'is valid' do
          expect(subject.success?).to be_truthy
        end
      end

      context 'and password is provided' do
        let(:params) { params_without_email }

        it 'is valid' do
          expect(subject.success?).to be_truthy
        end
      end
    end

    context 'when email provided without password' do
      let(:params) { valid_params.except(:password) }

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
