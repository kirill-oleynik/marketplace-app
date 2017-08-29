require 'rails_helper'

RSpec.describe RefreshSessionInteraction do
  subject(:result) do
    RefreshSessionInteraction.new(
      create_auth_credentials: create_auth_credentials,
      refresh_session_scheme: refresh_session_scheme,
      validate_refresh_token: validate_refresh_token
    ).call(params)
  end

  let(:create_auth_credentials) do
    double('create_auth_credentials', call: create_auth_credentials_result)
  end

  let(:create_auth_credentials_result) do
    create_auth_credentials_result = double('create_auth_credentials_result')

    allow(create_auth_credentials_result)
      .to receive_messages(
        success?: true,
        value: {
          'access_token' => 'access_token',
          'refresh_token' => 'refresh_token',
          'client_id' => 'client_id'
        }
      )

    create_auth_credentials_result
  end

  let(:refresh_session_scheme) do
    -> (_) { refresh_session_scheme_result }
  end

  let(:refresh_session_scheme_result) do
    double('refresh_session_scheme_result', success?: true)
  end

  let(:validate_refresh_token) do
    validate_refresh_token = double('validate_refresh_token')
    allow(validate_refresh_token)
      .to receive(:call)
      .and_return(double(success?: true, value: 'value'))
    validate_refresh_token
  end

  let(:params) do
    {
      'x-auth-token': 'token',
      'client-id': 'client_id'
    }
  end

  describe 'when params are invalid' do
    let(:refresh_session_scheme_result) do
      double('refresh_session_scheme_result', success?: false)
    end

    it 'returns Left monad with :invalid error' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
    end
  end

  describe 'when refresh token is invalid' do
    let(:validate_refresh_token) do
      validate_refresh_token = double('validate_refresh_token')
      allow(validate_refresh_token)
        .to receive(:call)
        .and_return(
          double(success?: false, value: [:unauthorized, ['desciption']])
        )
      validate_refresh_token
    end

    it 'returns Left monad with :unauthorized error' do
      expect(result).to be_left
    end
  end

  describe 'when all params are valid' do
    it 'creates and returns new auth credentials' do
      expect(result).to be_right
      expect(result.value).to have_key('refresh_token')
      expect(result.value).to have_key('access_token')
      expect(result.value).to have_key('client_id')
    end
  end
end
