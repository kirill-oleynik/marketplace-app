require 'rails_helper'

RSpec.describe 'Sessions requests' do
  describe '#create' do
    before(:each) do
      post sessions_path, params: params
    end

    let!(:password) { SecureRandom.hex(5) }

    context 'when params are valid', :with_db_cleaner do
      let!(:user) { create(:user, password: password) }

      let(:params) do
        {
          email: user.email,
          password: password
        }
      end

      it 'returns success response with credentials' do
        expect(response).to have_http_status(201)
        expect(response.body).to match_response_schema('session')
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
      let!(:user) { create(:user, password: password) }

      let(:params) do
        {
          email: "invalid#{user.email}",
          password: password
        }
      end

      it 'returns unauthorized error', :with_db_cleaner do
        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end

  describe '#refresh' do
    context 'when credentials are invalid' do
      before(:each) do
        put refresh_sessions_path, params: params
      end

      context 'when headers are not given' do
        let(:params) { {} }

        it 'returns 401 status with errors' do
          expect(response).to have_http_status(401)
          expect(response.body).to match_response_schema('errors/base')
        end
      end

      context 'when given headers are not valid' do
        let(:params) do
          {
            'refresh_token' => 'invalid_value',
            'client_id' => 'invalid_value'
          }
        end

        it 'returns 401 status with errors' do
          expect(response).to have_http_status(401)
          expect(response.body).to match_response_schema('errors/base')
        end
      end
    end

    context 'when credentials are valid', :with_db_cleaner do
      let!(:user) { create(:user) }

      let(:redis) { RedisAdapter.new }

      let(:bcrypt) { BcryptAdapter.new }

      let(:session_data) do
        {
          client_id: 'client_id',
          refresh_token_hash: bcrypt.encode('refresh_token'),
          user_id: user.id
        }
      end

      let(:params) do
        {
          'refresh_token' => 'refresh_token',
          'client_id' => 'client_id'
        }
      end

      before(:each) do
        redis.hmset('sess:client_id', session_data)
        put refresh_sessions_path, params: params
      end

      it 'returns 200 status with new credentials', :with_db_cleaner do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#destroy' do
    context 'when user has session', :with_db_cleaner do
      let(:password) { '123456' }
      let(:user) { create(:user, password: password) }

      it 'returns destroys user session' do
        authenticate_user(user.email, password) do |access_token|
          get current_user_path, headers: with_auth_header(access_token)

          expect(response).to have_http_status(200)

          delete sessions_path, headers: with_auth_header(access_token)

          expect(response).to have_http_status(200)

          get current_user_path, headers: with_auth_header(access_token)

          expect(response).to have_http_status(401)
          expect(response.body).to match_response_schema('errors/base')
        end
      end
    end

    context 'when user has not session' do
      it 'returns unauthorized error' do
        get favorites_path

        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end
end
