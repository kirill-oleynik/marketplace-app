require 'rails_helper'

RSpec.describe AuthenticateCommand do
  let(:user_session) do
    {
      'user_id' => '1',
      'client_id' => '2'
    }
  end

  let(:user) do
    build(:user, id: 1)
  end

  let(:jwt_adapter) do
    adapter = double('jwt_adapter')
    allow(adapter).to receive(:decode).with('jwt_token')
                                      .and_return(user_session)

    adapter
  end

  let(:user_repository) do
    repository = double('user_repository')
    allow(repository).to receive(:find).with('1')
                                       .and_return(user)

    repository
  end

  let(:session_storage) do
    session_storage = double('session_storage')
    allow(session_storage)
      .to receive(:exists?)
      .with(user.id.to_s, '2')
      .and_return(session_existance)

    session_storage
  end

  let(:session_existance) { true }

  subject do
    AuthenticateCommand.new(
      jwt: jwt_adapter,
      repository: user_repository,
      session_storage: session_storage
    )
  end

  context 'when token valid and user exists' do
    it 'returns right monad with user' do
      result = subject.call('jwt_token')

      expect(result).to be_right
      expect(result.value).to eq(user)
    end
  end

  context 'when token missing' do
    it 'returns left monad with unauthorized error tuple' do
      result = subject.call(nil)

      expect(result).to be_left
      expect(result.value.first).to eq(:unauthorized)
    end
  end

  context 'when token is expired' do
    let(:jwt_adapter) do
      adapter = double('jwt_adapter')
      allow(adapter).to receive(:decode).with('jwt_token')
                                        .and_raise(JWT::ExpiredSignature)

      adapter
    end

    it 'returns left monad with unauthorized error tuple' do
      result = subject.call('jwt_token')

      expect(result).to be_left
      expect(result.value.first).to eq(:unauthorized)
    end
  end

  context 'when token is invalid' do
    let(:jwt_adapter) do
      adapter = double('jwt_adapter')
      allow(adapter).to receive(:decode).with('jwt_token')
                                        .and_raise(JWT::DecodeError)

      adapter
    end

    it 'returns left monad with unauthorized error tuple' do
      result = subject.call('jwt_token')

      expect(result).to be_left
      expect(result.value.first).to eq(:unauthorized)
    end
  end

  context 'when user not found' do
    let(:user_repository) do
      repo = double('user_repository')
      allow(repo).to receive(:find).with('1')
                                   .and_raise(ActiveRecord::RecordNotFound)

      repo
    end

    it 'returns left monad with unauthorized error tuple' do
      result = subject.call('jwt_token')

      expect(result).to be_left
      expect(result.value.first).to eq(:unauthorized)
    end
  end

  context 'when session was expired serverside' do
    let(:session_existance) { false }

    it 'returns left monad with unauthorized error tuple' do
      result = subject.call('jwt_token')

      expect(result).to be_left
      expect(result.value.first).to eq(:unauthorized)
    end
  end
end
