require 'rails_helper'

RSpec.describe PasswordRecovery::FinalizeScheme do
  subject { PasswordRecovery::FinalizeScheme.call(params) }
  let(:valid_params) do
    {
      recovery_token: 'recovery_token',
      password: 'password',
      password_confirmation: 'password'
    }
  end

  describe 'when all params valid' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  context 'when params are invalid' do
    describe 'recovery_token' do
      context 'when value is missing' do
        let(:params) { valid_params.except(:recovery_token) }

        it 'is invalid' do
          expect(subject.success?).to be_falsey
        end
      end

      context 'when value has incorrect format' do
        let(:params) { valid_params.merge(recovery_token: nil) }

        it 'is invalid' do
          expect(subject.success?).to be_falsey
        end
      end
    end

    describe 'password validation' do
      include_examples 'password validation'
    end

    describe 'password_confirmation' do
      include_examples 'password_confirmation validation'
    end
  end
end
