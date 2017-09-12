require 'rails_helper'

RSpec.describe ChangePasswordScheme do
  let(:subject) { described_class.call(params) }
  let(:valid_params) do
    attributes_for(:user).merge(
      user: attributes_for(:user),
      current_password: 'password',
      password: 'new_password',
      password_confirmation: 'new_password',
      token: 'jwt_token'
    )
  end

  describe 'when all params valid' do
    let(:params) { valid_params }

    it 'is valid' do
      expect(subject.success?).to be_truthy
    end
  end

  describe 'user' do
    context 'when value is not given' do
      let(:params) { valid_params.except(:user) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'current_password' do
    context 'when value is not given' do
      let(:params) { valid_params.except(:current_password) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end

  describe 'password' do
    include_examples 'password validation'
  end

  describe 'password_confirmation' do
    include_examples 'password_confirmation validation'
  end

  describe 'token' do
    context 'when value is not given' do
      let(:params) { valid_params.except(:token) }

      it 'is invalid' do
        expect(subject.success?).to be_falsey
      end
    end
  end
end
