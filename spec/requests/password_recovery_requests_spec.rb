require('rails_helper')

RSpec.describe 'PasswordRecovery requests' do
  describe '#create' do
    context 'when params are valid', :with_db_cleaner do
      let(:user) { create(:user) }
      let(:params) { { email: user.email } }

      before do
        post user_password_recovery_path, params: params
      end

      it 'returns 202 accepted with user email' do
        expect(response).to have_http_status(202)
        expect(JSON.parse(response.body)).to eq('email' => user.email)
      end
    end

    context 'when params are invalid' do
      let(:params) { { email: 'invalid@email.com' } }

      before do
        post user_password_recovery_path, params: params
      end

      it 'returns 422 with errors' do
        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/validation')
      end
    end
  end

  describe '#udpate' do
    let(:params) do
      {
        user_id: user_id,
        recovery_token: recovery_token,
        password: 'password',
        password_confirmation: 'password'
      }
    end

    before do
      put user_password_recovery_path, params: params
    end

    context 'when params are valid', :with_db_cleaner do
      let(:user) { create(:user) }
      let(:user_id) { user.id }
      let(:recovery_token) { recovery_token_for(user) }

      it 'returns 201 created with updated user' do
        expect(response).to have_http_status(201)
        expect(response.body).to match_response_schema('user')
      end
    end

    context 'when params are invalid' do
      let(:user_id) { build(:user, id: 1) }
      let(:recovery_token) { 'invalid' }

      it 'returns 401 unauthorized' do
        expect(response).to have_http_status(401)
        expect(response.body).to match_response_schema('errors/base')
      end
    end
  end

  private

  def recovery_token_for(user)
    JwtAdapter.new.encode({ user_id: user.id }, user.password_hash)
  end
end
