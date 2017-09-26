require('rails_helper')

RSpec.describe 'PasswordRecovery requests' do
  context 'when params are valid' do
    let(:user) { create(:user) }
    let(:params) { { email: user.email } }

    before do
      post user_password_recovery_path, params: params
    end

    it 'returns 202 accepted with user email', :with_db_cleaner do
      expect(response).to have_http_status(202)
      expect(JSON.parse(response.body)).to eq('email' => user.email)
    end
  end

  context 'when params are invalid' do
    let(:params) { { email: 'invalid@email.com' } }

    before do
      post user_password_recovery_path, params: params
    end

    it 'returns 202 accepted with user email' do
      expect(response).to have_http_status(404)
      expect(response.body).to match_response_schema('errors/base')
    end
  end
end
