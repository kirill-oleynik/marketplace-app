require 'rails_helper'

RSpec.describe ValidateRefreshTokenCommand do
  subject(:result) do
    ValidateRefreshTokenCommand.new(
      bcrypt: bctypt,
      redis: redis,
      repository: repository
    ).call(input)
  end

  let(:input) do
    {
      'x-auth-token' => 'token',
      'client-id' => 'client_id'
    }
  end

  let(:bctypt) do
    double('bcrypt', encode_with_salt: encoded_refresh_token)
  end

  let(:encoded_refresh_token) { 'refresh_token' }

  let(:redis) do
    double('redis', exists: false, get: session_data.to_json)
  end

  let(:session_data) do
    {
      'refresh_token' => 'refresh_token',
      'user_id' => 'user_id'
    }
  end

  let(:repository) { double('repository', find: 'user') }

  context 'when client-id not exists' do
    let(:redis) do
      double('redis', exists: false, get: nil)
    end

    it 'returns Left monad with :unauthorized error' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when given token is invalid' do
    let(:encoded_refresh_token) { 'invalid_encoded_refresh_token' }

    it 'returns Left monad with :unauthorized error' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when user from session data not exists' do
    let(:repository) do
      repository = double('repository')
      allow(repository)
        .to receive(:find)
        .and_raise(ActiveRecord::RecordNotFound)

      repository
    end

    it 'returns Left monad with :unauthorized error' do
      # byebug
      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when all params are valid' do
    let(:expected_output) { input.merge(session_data).merge(user: 'user') }

    it 'returns Right monad with session_data' do
      expect(result.value).to eq(expected_output)
    end
  end
end
