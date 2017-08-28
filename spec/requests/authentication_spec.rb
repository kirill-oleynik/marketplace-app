require 'rails_helper'

RSpec.describe 'Authentication' do
  before(:each) do
    post users_path, params: nil, headers: headers
  end

  describe 'when x-auth-token does not provided' do
    let(:headers) { {} }

    skip 'returns 422' do
      expect(response).to have_http_status(422)
    end
  end

  describe 'when access token is expired' do
    let!(:user) { create(:user) }

    let(:headers) do
      { 'x-auth-token' => expired_token }
    end

    let(:expired_token) do
      JwtAdapter.new.encode(
        user_id: user.id,
        exp: Time.now.to_i - 100
      )
    end

    let(:random_value) { SecureRandom.hex(5) }

    skip 'returns 401', :with_db_cleaner do
      expect(response).to have_http_status(401)
    end
  end
end
