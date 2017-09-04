require 'rails_helper'

RSpec.describe SignInInteraction do
  let(:user) { build(:user) }
  let(:session) { Session.new(attributes_for(:session)) }

  let(:bcrypt) { double(compare: true) }
  let(:sign_in_scheme) { -> (*) { double(success?: true) } }
  let(:create_session) { -> (*) { double(value: session) } }
  let(:repository) { double(find_by_email: user) }

  let(:params) do
    {
      email: user.email,
      password: '123456'
    }
  end

  subject(:result) do
    SignInInteraction.new(
      bcrypt: bcrypt,
      sign_in_scheme: sign_in_scheme,
      create_session: create_session,
      repository: repository
    )
  end

  context 'when transaction was successfull' do
    it 'returns right monad with created session' do
      result = subject.call(params)

      expect(result).to be_right
      expect(result.value).to eq(session)
    end
  end

  context 'when validation failed' do
    let(:params) { {} }
    let(:sign_in_scheme) do
      -> (*) { double(success?: false, errors: 'Ooops!') }
    end

    it 'is returns left monad with validation error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('Ooops!')
    end
  end

  context 'when user not found' do
    let(:repository) { double(find_by_email: nil) }

    it 'is returns left monad with unauthorized error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when passwords not equal' do
    let(:bcrypt) { double(compare: false) }

    it 'is returns left monad with unauthorized error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end
end
