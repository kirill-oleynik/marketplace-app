require 'rails_helper'

RSpec.describe CreateAuthCredentialsCommand do
  subject(:result) do
    CreateAuthCredentialsCommand.new(
      jwt: jwt,
      bcrypt: bctypt,
      redis: redis
    ).call(input)
  end

  let(:input) do
    { user: build(:user, id: 1) }
  end

  let(:jwt) do
    double('jwt', encode: 'access_token')
  end

  let(:bctypt) do
    double('bcrypt', encode: 'encoded_refresh_token')
  end

  let(:redis) do
    double('redis', exists: false, set: :ok, expire: :ok)
  end

  before(:each) do
    allow(SecureRandom).to receive(:hex).and_return('random_value')
  end

  it 'returns hash with access token, refresh token and client id' do
    output = input.merge(
      access_token: 'access_token',
      refresh_token: 'random_value',
      client_id: 'random_value'
    )

    expect(result.value).to eq(output)
  end
end
