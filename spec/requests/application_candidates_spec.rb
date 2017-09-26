require('rails_helper')

RSpec.describe 'ApplicationCandidates requests' do
  let(:password) { '123456' }
  let(:user) { create(:user, password: 'password') }
  let(:valid_params) do
    {
      url: 'example.com',
      description: 'description'
    }
  end

  context 'when params are valid', :with_db_cleaner do
    let(:params) { valid_params }

    it 'creates application_candidate and responds with 200 with right json' do
      expect(application_candidates_count).to eq(0)

      create_request do
        expect(application_candidates_count).to eq(1)
        expect(response).to have_http_status(200)
        expect(response.body).to match_response_schema('application_candidate')
      end
    end
  end

  context 'when params are invalid', :with_db_cleaner do
    let(:params) { valid_params.except(:url) }

    it 'does not create application candidate and responds with error' do
      expect(application_candidates_count).to eq(0)

      create_request do
        expect(application_candidates_count).to eq(0)
        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/validation')
      end
    end
  end

  private

  def create_request
    authenticate_user(user.email, 'password') do |access_token|
      post application_candidates_path(params),
           headers: with_auth_header(access_token)

      yield(response)
    end
  end

  def application_candidates_count
    ApplicationCandidate.count
  end
end
