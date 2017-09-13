require 'rails_helper'

RSpec.describe ChangePasswordInteraction do
  subject do
    described_class.new(
      change_password_scheme: change_password_scheme,
      bcrypt: bcrypt,
      repository: repository,
      session_repository: session_repository,
      jwt: jwt
    ).call(params)
  end

  let(:params) do
    {
      user: user,
      current_password: 'current_password',
      password: 'new_password',
      password_confirmation: 'new_password',
      token: 'jwt_token'
    }
  end

  let(:change_password_scheme) { -> (_) { double(success?: true) } }

  let(:bcrypt) { double('bcrypt', compare: true, encode: 'encoded') }

  let(:repository) { double('repository', update!: user) }

  let(:user) do
    double('user', password_hash: 'password_hash', id: 'id')
  end

  let(:session_repository) { double(delete_sessions: true) }

  let(:jwt) do
    jwt = double('jwt')
    allow(jwt).to receive(:decode).with('jwt_token').and_return(decoded_token)
    jwt
  end

  let(:decoded_token) { { payload: { client_id: 'client_id' } } }

  describe 'when params invalid' do
    let(:change_password_scheme) do
      -> (_) { double(success?: false, errors: 'errors') }
    end

    it 'returns left monad with violations' do
      expect(subject).to be_left
      expect(subject.value[0]).to eq(:invalid)
      expect(subject.value[1]).to eq('errors')
    end
  end

  describe 'when params are valid' do
    context 'but current_password is incorrect' do
      let(:bcrypt) { double(compare: false) }

      it 'returns left monad with violations' do
        expect(subject).to be_left
        expect(subject.value[0]).to eq(:invalid)
      end
    end

    it 'returns right monad with updated user' do
      expect(subject).to be_right
      expect(subject.value).to eq(user)
    end
  end
end
