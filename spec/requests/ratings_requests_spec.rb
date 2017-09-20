require 'rails_helper'

RSpec.describe 'Ratings Requests' do
  let!(:user) { create(:user, password: 'password') }
  let(:application) { create(:application) }
  let(:rating) { create(:rating, application_id: application.id) }

  describe '#show' do
    context 'when application exists' do
      let(:params) { application.slug }

      it 'has successful response with serialized rating', :with_db_cleaner do
        show_rating_request do
          expect(response).to have_http_status(200)
          expect(response.body).to match_response_schema('rating')
        end
      end
    end

    context 'when application does not exist' do
      let(:params) { 'invalid' }

      it 'returns 422 status with error', :with_db_cleaner do
        show_rating_request do
          expect(response).to have_http_status(404)
          expect(response.body).to match_response_schema('errors/base')
        end
      end
    end
  end

  private

  def show_rating_request
    authenticate_user(user.email, 'password') do |access_token|
      get application_rating_path(params),
          headers: with_auth_header(access_token)

      yield(response)
    end
  end
end
