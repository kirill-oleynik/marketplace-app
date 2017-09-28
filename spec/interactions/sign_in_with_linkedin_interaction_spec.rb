require 'rails_helper'

RSpec.describe SignInWithLinkedinInteraction do
  let(:user) { build(:user) }
  let(:session) { Session.new(attributes_for(:session)) }
  let(:params) { attributes_for(:user) }

  let(:bcrypt) { double(encode: 'bcrypt_hash') }
  let(:repository) { double(find_by_email: user) }
  let(:create_session) { -> (*) { double(value: session) } }
  let(:get_oauth_redirect_url) { -> (*) { redirect_url_from_session(session) } }

  subject(:result) do
    SignInWithLinkedinInteraction.new(
      bcrypt: bcrypt,
      repository: repository,
      create_session: create_session,
      get_oauth_redirect_url: get_oauth_redirect_url
    )
  end

  context 'when transaction was successfull' do
    context 'when user already exists' do
      it 'returns right monad with redirect url' do
        result = subject.call(params)

        expect(result).to be_right
        expect(result.value).to eq(
          redirect_url_from_session(session)
        )
      end
    end

    context 'when user not exits' do
      let(:user_create_params) { params.merge(password_hash: 'bcrypt_hash') }

      let(:repository) do
        repository_mock do |mock|
          expect(mock).to receive(:find_by_email)
            .with(params[:email]).and_return(nil)

          expect(mock).to receive(:create!)
            .with(user_create_params).and_return(user)
        end
      end

      it 'creates user and returns right monad with redirect url' do
        result = subject.call(params)

        expect(result).to be_right
        expect(result.value).to eq(
          redirect_url_from_session(session)
        )
      end
    end
  end

  def redirect_url_from_session(session)
    base = '/oauth/callback?'
    base << "accessToken=#{session.access_token}"
    base << "&clientId=#{session.client_id}"
    base << "&refreshToken=#{session.refresh_token}"
  end
end
