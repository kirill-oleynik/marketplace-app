require 'rails_helper'

RSpec.describe 'Sessions requests' do
  describe '#create' do
    before(:each) do
      post sessions_path, params: params
    end

    let!(:password) { SecureRandom.hex(5) }

    context 'when params are valid' do
      let!(:user) { create(:user, password_hash: password_hash(password)) }

      let(:params) do
        {
          email: user.email,
          password: password
        }
      end

      it 'returns success response with credentials', :with_db_cleaner do
        expect(response).to have_http_status(200)

        body = JSON.parse(response.body)

        expect(body).to include('access_token')
        expect(body).to include('refresh_token')
        expect(body).to include('client_id')
      end
    end

    context 'when params is invalid' do
      let(:params) do
        {
          email: 'johndou:example.com'
        }
      end

      it 'returns 422 error' do
        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/validation')
      end
    end

    context 'when email is wrong' do
      let!(:user) { create(:user, password_hash: password_hash(password)) }

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
  end

  describe '#update' do
    context 'when credentials are invalid' do
      before(:each) do
        put session_path, headers: headers
      end

      context 'when headers are not given' do
        let(:headers) { {} }

        it 'returns 422 status with errors' do
          expect(response).to have_http_status(422)
          expect(response.body).to match_response_schema('errors/authorization')
        end
      end

      context 'when given headers are not valid' do
        let(:headers) do
          {
            'x-auth-token' => 'invalid_value',
            'client-id' => 'invalid_value'
          }
        end

        it 'returns 401 status with errors' do
          expect(response).to have_http_status(401)
          expect(response.body).to match_response_schema('errors/authorization')
        end
      end
    end

    context 'when credentials are valid' do
      let!(:user) { create(:user) }

      let(:redis) { RedisAdapter.new }

      let(:bcrypt) { BcryptAdapter.new }

      let(:session_data) do
        {
          client_id: 'client_id',
          refresh_token: bcrypt.encode('refresh_token'),
          user_id: user.id
        }
      end

      let(:headers) do
        {
          'x-auth-token' => 'refresh_token',
          'client-id' => 'client_id'
        }
      end

      before(:each) do
        redis.set('client_id', session_data.to_json)
        put session_path, headers: headers
      end

      it 'returns 200 status with new credentials', :with_db_cleaner do
        expect(response).to have_http_status(200)
      end
    end
  end
end
