require 'rails_helper'

RSpec.describe 'Reviews Requests' do
  let!(:user) { create(:user, password: 'password') }
  let(:application) { create(:application) }

  let(:valid_params) do
    {
      application_id: application.id,
      value: '5'
    }
  end

  context 'when params are invalid', :with_db_cleaner do
    let(:params) { valid_params.except(:value) }

    it 'returns 422 status code with errors' do
      create_review_request do
        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/validation')
      end
    end
  end

  context 'when all params are valid', :with_db_cleaner do
    let(:params) { valid_params }

    it 'creates new review and returns 200 status with serialized review' do
      expect(reviews_count).to eq(0)

      create_review_request do
        expect(reviews_count).to eq(1)
        expect(review_app).to eq(application)
        expect(review_user).to eq(user)

        expect(response).to have_http_status(200)
        expect(response.body).to match_response_schema('review')
      end
    end
  end

  private

  def create_review_request
    authenticate_user(user.email, 'password') do |access_token|
      post reviews_path, params: params,
                         headers: with_auth_header(access_token)

      yield(response)
    end
  end

  def reviews_count
    Review.count
  end

  def review_app
    Review.first.application
  end

  def review_user
    Review.first.user
  end
end
