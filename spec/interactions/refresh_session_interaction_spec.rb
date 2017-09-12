require 'rails_helper'

RSpec.describe RefreshSessionInteraction do
  let(:user) { build(:user) }
  let(:session) { Session.new(attributes_for(:session)) }
  let(:session_data) do
    {
      user_id: user.id,
      refresh_token_hash: 'refresh_token_hash'
    }
  end

  let(:bcrypt) { double(compare: true) }
  let(:refresh_session_scheme) { -> (*) { double(success?: true) } }
  let(:create_session) { -> (*) { double(value: session) } }
  let(:user_repository) { double(find: user) }
  let(:session_storage) { double(find: session_data) }

  let(:params) do
    {
      client_id: session.client_id,
      refresh_token: session.refresh_token
    }
  end

  subject(:result) do
    RefreshSessionInteraction.new(
      bcrypt: bcrypt,
      repository: user_repository,
      create_session: create_session,
      refresh_session_scheme: refresh_session_scheme,
      session: session,
      session_storage: session_storage
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
    let(:refresh_session_scheme) do
      -> (*) { double(success?: false, errors: 'Ooops!') }
    end

    it 'is returns left monad with unauthorized error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when session data not found' do
    let(:session_storage) { double(find: nil) }

    it 'is returns left monad with unauthorized error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when refresh tokens not equal' do
    let(:bcrypt) { double(compare: false) }

    it 'is returns left monad with unauthorized error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when user not found' do
    let(:user_repository) do
      mock = double
      expect(mock).to receive(:find).with(user.id)
                                    .and_raise(ActiveRecord::RecordNotFound)
      mock
    end

    it 'is returns left monad with unauthorized error tuple' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end
end
