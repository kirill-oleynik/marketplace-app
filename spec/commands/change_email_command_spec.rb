require 'rails_helper'

RSpec.describe ChangeEmailCommand do
  subject do
    ChangeEmailCommand.new(
      bcrypt: bcrypt
    )
  end

  let(:params) do
    {
      email: email,
      password: 'password',
      user: user
    }
  end

  let(:email) { attributes_for(:user)[:email] }

  let(:user) do
    user = double('user')
    allow(user).to receive_messages([:password_hash, :update])
    user
  end

  context 'when given password matches user password' do
    let(:bcrypt) { double(compare: true) }

    it 'updates user email' do
      expect(user).to receive(:update).with(email: email)
      subject.call(params)
    end

    it 'returns rigth monad' do
      result = subject.call(params)

      expect(result).to be_right
    end
  end

  context 'when given password not matches user password' do
    let(:bcrypt) { double(compare: false) }

    it 'updates user email' do
      expect(user).not_to receive(:update).with(email: email)
      subject.call(params)
    end

    it 'returns rigth monad' do
      result = subject.call(params)

      expect(result).to be_left
    end
  end
end
