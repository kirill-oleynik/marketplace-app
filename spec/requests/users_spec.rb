require 'rails_helper'

RSpec.describe 'Users requests' do
  describe '#create' do
    context 'when params valid' do
      let(:params) do
        attributes_for(:user).merge(
          password: '123456',
          password_confirmation: '123456'
        )
      end

      it 'creates user', :with_db_cleaner do
        expect(users_count).to eq(0)

        post users_path, params: params

        expect(response).to have_http_status(201)
        expect(response.body).to match_response_schema('user')
        expect(users_count).to eq(1)
      end
    end

    context 'when params invalid' do
      let(:params) do
        attributes_for(:user).merge(
          email: nil
        )
      end

      it 'returns validation errors', :with_db_cleaner do
        post users_path, params: params

        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/validation')
        expect(users_count).to eq(0)
      end
    end

    context 'when email already taken' do
      let(:params) do
        attributes_for(:user).merge(
          password: '123456',
          password_confirmation: '123456'
        )
      end

      it 'returns validation errors', :with_db_cleaner do
        expect(users_count).to eq(0)

        2.times { post users_path, params: params }

        expect(response).to have_http_status(422)
        expect(response.body).to match_response_schema('errors/validation')
        expect(users_count).to eq(1)
      end
    end
  end

  describe '#show' do
    let(:password) { '123456' }
    let(:encoded_password) { password_hash(password) }
    let(:user) { create(:user, password_hash: encoded_password) }

    it 'returns serialized user data', :with_db_cleaner do
      authenticate_user(user.email, password) do |access_token|
        get current_users_path, headers: with_auth_header(access_token)

        expect(response).to have_http_status(200)
        expect(response.body).to match_response_schema('user')
      end
    end
  end

  describe '#update' do
    let(:password) { '123456' }
    let(:encoded_password) { password_hash(password) }
    let(:user) { create(:user, password_hash: encoded_password) }

    context 'when params valid' do
      let(:params) do
        {
          first_name: 'FirstName',
          phone: '123'
        }
      end

      it 'updates user and profile', :with_db_cleaner do
        authenticate_user user.email, password do |access_token|
          put user_path(user.id),
              params: params,
              headers: with_auth_header(access_token)

          expect(response).to have_http_status(200)
          expect(response.body).to match_response_schema('user')
          expect(Profile.find_by_user_id(user.id).phone).to eq(params[:phone])
          expect(User.find(user.id).first_name).to eq(params[:first_name])
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
          put user_path(user.id),
              params: params,
              headers: with_auth_header(access_token)

          expect(response).to have_http_status(422)
          expect(response.body).to match_response_schema('errors/validation')
        end
      end
    end
  end

  def users_count
    User.count
  end
end
