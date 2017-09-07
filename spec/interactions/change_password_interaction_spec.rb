require 'rails_helper'

RSpec.describe ChangePasswordInteraction do
  subject do
    described_class.new(
      change_password_scheme: change_password_scheme,
      bcrypt: bcrypt
    ).call(params)
  end

  let(:params) do
    {
      user: user,
      current_password: 'current_password',
      password: 'new_password',
      password_confirmation: 'new_password'
    }
  end

  let(:change_password_scheme) { -> (_) { double(success?: true) } }

  let(:bcrypt) { double('bcrypt', compare: true, encode: 'encoded') }

  let(:user) { double('user', update: true, password_hash: 'password_hash') }

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
