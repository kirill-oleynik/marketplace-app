require 'rails_helper'

RSpec.describe 'Sessions requests' do
  describe '#create' do
    before(:each) do
      post sessions_path, params: params
    end

    let!(:user) { create(:user, password_hash: password_hash(password)) }
    let!(:password) { SecureRandom.hex(5) }

    context 'when params are valid' do
      let(:params) do
        {
          email: user.email,
          password: password
        }
      end

      it 'returns success response with credentials', :with_db_cleaner do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)).to include('access_token')
        expect(JSON.parse(response.body)).to include('refresh_token')
        expect(JSON.parse(response.body)).to include('client_id')
      end
    end

    context 'when password is invalid' do
      let(:params) do
        {
          email: user.email,
          password: 'invalid'
        }
      end

      it 'returns authorization error', :with_db_cleaner do
        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/authorization')
      end
    end

    context 'when password has invalid format' do
      let(:params) do
        {
          email: user.email,
          password: ''
        }
      end

      it 'returns 422 error', :with_db_cleaner do
        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/authorization')
      end
    end

    context 'when email is invalid' do
      let(:params) do
        {
          email: "invalid#{user.email}",
          password: password
        }
      end

      it 'returns unauthorized error', :with_db_cleaner do
        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/authorization')
      end
    end

    context 'when email has invalid format' do
      let(:params) do
        {
          email: 'invalid',
          password: password
        }
      end

      it 'returns 422 error', :with_db_cleaner do
        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/authorization')
      end
    end
  end
end
