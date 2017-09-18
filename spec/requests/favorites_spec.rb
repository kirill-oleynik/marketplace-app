require 'rails_helper'

RSpec.describe 'Favorites requests' do
  let(:password) { '123456' }
  let(:user) { create(:user, password: password) }

  describe '#create' do
    let(:application) { create(:application) }

    context 'when user has session' do
      context 'when params valid' do
        it 'creates favorite', :with_db_cleaner do
          expect(favorites_count).to eq(0)

          authenticate_user(user.email, password) do |access_token|
            post(
              application_favorites_path(application),
              headers: with_auth_header(access_token)
            )

            expect(response).to have_http_status(201)
            expect(response.body).to match_response_schema('favorite')
            expect(favorites_count).to eq(1)
          end
        end
      end

      context 'when application not exists' do
        it 'returns not found error', :with_db_cleaner do
          authenticate_user(user.email, password) do |access_token|
            post(
              application_favorites_path(1),
              headers: with_auth_header(access_token)
            )

            expect(response).to have_http_status(404)
            expect(response.body).to match_response_schema('errors/base')
          end
        end
      end

      context 'when user already add application to favorites' do
        it 'returns validation errors', :with_db_cleaner do
          authenticate_user(user.email, password) do |access_token|
            post(
              application_favorites_path(application),
              headers: with_auth_header(access_token)
            )

            post(
              application_favorites_path(application),
              headers: with_auth_header(access_token)
            )

            expect(response).to have_http_status(422)
            expect(response.body).to match_response_schema('errors/validation')
          end
        end
      end
    end

    context 'when user has not session' do
      it 'returns unauthorized error' do
        post application_favorites_path(1)

        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end

  describe '#destroy' do
    context 'when user has session' do
      context 'when params valid' do
        let!(:favorite) { create(:favorite, user: user) }

        it 'destroys favorite', :with_db_cleaner do
          expect(favorites_count).to eq(1)

          authenticate_user(user.email, password) do |access_token|
            delete(
              favorite_path(favorite),
              headers: with_auth_header(access_token)
            )

            expect(response).to have_http_status(200)
            expect(response.body).to match_response_schema('favorite')
            expect(favorites_count).to eq(0)
          end
        end
      end

      context 'when favorite not exists' do
        it 'returns not found error', :with_db_cleaner do
          authenticate_user(user.email, password) do |access_token|
            delete(
              favorite_path(1),
              headers: with_auth_header(access_token)
            )

            expect(response).to have_http_status(404)
            expect(response.body).to match_response_schema('errors/base')
          end
        end
      end

      context 'when favorite does not belongs to user' do
        let!(:favorite) { create(:favorite) }

        it 'returns forbidden error', :with_db_cleaner do
          authenticate_user(user.email, password) do |access_token|
            delete(
              favorite_path(favorite),
              headers: with_auth_header(access_token)
            )

            expect(response).to have_http_status(403)
            expect(response.body).to match_response_schema('errors/base')
          end
        end
      end
    end

    context 'when user has not session' do
      it 'returns unauthorized error' do
        post application_favorites_path(1)

        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end

  def favorites_count
    Favorite.count
  end
end
