require 'rails_helper'

RSpec.describe 'Current User requests' do
  let(:password) { '123456' }
  let(:encoded_password) { password_hash(password) }
  let(:user) { create(:user, password_hash: encoded_password) }

  describe '#show' do
    it 'returns serialized user data', :with_db_cleaner do
      authenticate_user(user.email, password) do |access_token|
        get current_user_path, headers: with_auth_header(access_token)

        expect(response).to have_http_status(200)
        expect(response.body).to match_response_schema('user')
      end
    end
  end

  describe '#update' do
    context 'when params valid' do
      let(:params) do
        {
          first_name: 'FirstName',
          last_name: 'LastName',
          phone: '123',
          job_title: 'job_title',
          organization: 'organization'
        }
      end

      it 'updates user and profile', :with_db_cleaner do
        authenticate_user user.email, password do |access_token|
          put current_user_path,
              params: params,
              headers: with_auth_header(access_token)

          expect(response).to have_http_status(200)
          expect(response.body).to match_response_schema('user')

          expect(User.find(user.id).first_name).to eq(params[:first_name])
          expect(User.find(user.id).last_name).to eq(params[:last_name])

          expect(
            Profile.find_by_user_id(user.id).phone
          ).to eq(params[:phone])
          expect(
            Profile.find_by_user_id(user.id).organization
          ).to eq(params[:organization])
          expect(
            Profile.find_by_user_id(user.id).job_title
          ).to eq(params[:job_title])
        end
      end
    end

    context 'when params invalid' do
      let(:params) do
        {
          email: 'email',
          phone: 'phone'
        }
      end

      it 'returns errors', :with_db_cleaner do
        authenticate_user user.email, password do |access_token|
          put current_user_path,
              params: params,
              headers: with_auth_header(access_token)

          expect(response).to have_http_status(422)
          expect(response.body).to match_response_schema('errors/validation')
        end
      end
    end
  end

  describe '#password' do
    let(:new_password) { 'new_password' }

    let(:valid_params) do
      {
        current_password: password,
        password: new_password,
        password_confirmation: new_password
      }
    end

    describe 'when params are valid' do
      let(:params) { valid_params }

      before(:each) do
        authenticate_user(user.email, password)
      end

      it 'updates user password', :with_db_cleaner do
        authenticate_user user.email, password do |access_token, client_id|
          put password_current_user_path,
              params: params,
              headers: with_auth_header(access_token, 'ClientId' => client_id)

          user.reload

          expect(response).to have_http_status(200)
          expect(response.body).to match_response_schema('user')
          expect(compare_password(new_password, user)).to be_truthy
        end
      end
    end

    describe 'when params are invalid' do
      let(:params) { valid_params.except(:password) }

      it 'returns errors', :with_db_cleaner do
        authenticate_user user.email, password do |access_token|
          put password_current_user_path,
              params: params,
              headers: with_auth_header(access_token)

          expect(response).to have_http_status(422)
          expect(response.body).to match_response_schema('errors/validation')
        end
      end
    end
  end

  def compare_password(secret, user)
    BcryptAdapter.new.compare(secret: secret, secret_hash: user.password_hash)
  end
end
