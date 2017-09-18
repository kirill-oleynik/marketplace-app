require 'rails_helper'

RSpec.describe 'Profiles requests' do
  describe '#create' do
    let(:password) { '123456' }
    let(:user) { create(:user, password: password) }

    context 'when params valid' do
      let(:params) { attributes_for(:profile) }

      it 'creates profile for current user', :with_db_cleaner do
        authenticate_user user.email, password do |access_token|
          expect(Profile.find_by_user_id(user.id)).not_to be_present

          post profile_path, params: params,
                             headers: with_auth_header(access_token)

          expect(response).to have_http_status(201)
          expect(response.body).to match_response_schema('profile')
          expect(Profile.find_by_user_id(user.id)).to be_present
        end
      end
    end

    context 'when params are invalid' do
      let(:params) { attributes_for(:profile).merge(phone: nil) }

      it 'returns unprocessable entity response', :with_db_cleaner do
        authenticate_user user.email, password do |access_token|
          post profile_path, params: params,
                             headers: with_auth_header(access_token)

          expect(response).to have_http_status(422)
          expect(response.body).to match_response_schema('errors/validation')
          expect(Profile.find_by_user_id(user.id)).not_to be_present
        end
      end
    end

    context 'when user not logged in' do
      it 'returns unauthorized response' do
        post profile_path

        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/base')
        expect(Profile.find_by_user_id(user.id)).not_to be_present
      end
    end
  end
end
