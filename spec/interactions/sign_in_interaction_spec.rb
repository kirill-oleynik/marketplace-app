require 'rails_helper'

RSpec.describe SignInInteraction do
  subject(:result) do
    SignInInteraction.new(
      sign_in_scheme: sign_in_scheme,
      bcrypt: bcrypt,
      create_auth_credentials: create_auth_credentials,
      repository: repository
    ).call(params)
  end

  let!(:user) do
    create(:user, password_hash: encoded_password)
  end

  let(:repository) do
    mock = double('repository')

    def mock.find_by(condition)
      User.find_by(condition)
    end

    mock
  end

  let!(:encoded_password) { password_hash(password) }
  let(:password) { SecureRandom.hex(5) }

  let(:sign_in_scheme_result) do
    double('sign_in_scheme_result', success?: true)
  end

  let(:sign_in_scheme) do
    -> (_) { sign_in_scheme_result }
  end

  let(:bcrypt) do
    double('bcrypt', encode_with_salt: encoded_password)
  end

  let(:access_token) { 'access_token' }
  let(:refresh_token) { 'refresh_token' }
  let(:client_id) { 'client_id' }

  let(:create_auth_credentials) do
    double('create_auth_credentials', call: double(value: {
      access_token: access_token,
      refresh_token: refresh_token,
      client_id: client_id
    }))
  end

  describe 'when given params are valid' do
    let(:params) do
      {
        email: user.email,
        password: password
      }
    end

    it 'returns right monad with credentials' do
      expect(result).to be_right
      expect(result.value[:access_token]).to eq(access_token)
      expect(result.value[:refresh_token]).to eq(refresh_token)
      expect(result.value[:client_id]).to eq(client_id)
    end
  end

  describe 'when given email is invalid' do
    let(:params) do
      {
        email: 'ivalid',
        password: password
      }
    end

    it 'returns right monad with credentials' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  describe 'when given password is invalid' do
    let(:params) do
      {
        email: user.email,
        password: 'invalid'
      }
    end

    let(:bcrypt) do
      double('bcrypt', encode_with_salt: 'invalid_hash')
    end

    it 'returns right monad with credentials' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end
end
