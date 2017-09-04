require 'rails_helper'

RSpec.describe CreateSessionCommand do
  let(:jwt) { double(encode: 'jwt_token') }
  let(:bcrypt) { double(encode: 'bcrypt_token') }
  let(:redis) { double(exists: false, hmset: true, expire: true) }

  subject(:result) do
    CreateSessionCommand.new(
      jwt: jwt,
      bcrypt: bcrypt,
      redis: redis
    )
  end

  it 'returns right monad with new session' do
    allow(SecureRandom).to receive(:urlsafe_base64).and_return('base64')

    result = subject.call(user_id: 1)

    expect(result).to be_right
    expect(result.value.client_id).to eq('base64')
    expect(result.value.refresh_token).to eq('base64')
    expect(result.value.access_token).to eq('jwt_token')
  end
end
