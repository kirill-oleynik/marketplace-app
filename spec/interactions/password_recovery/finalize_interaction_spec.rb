require('rails_helper')

RSpec.describe PasswordRecovery::FinalizeInteraction do
  subject do
    described_class.new(
      validation_scheme: validation_scheme,
      jwt: jwt,
      change_password: change_password,
      session_repository: session_repository,
      user_repository: user_repository
    )
  end

  let(:validation_scheme) { -> (_) { double(success?: true) } }
  let(:user_repository) { double(find: user) }

  let(:session_repository) do
    repository = double('session_repository')

    allow(repository)
      .to receive(:delete_sessions)
      .with(user_id: 1)

    repository
  end

  let(:change_password) do
    command = double('change_password')

    allow(command)
      .to receive(:call)
      .with(user: user, password: 'password')
      .and_return(double(value: updated_user))

    command
  end

  let(:jwt) do
    adapter = double('jwt_adapter')

    allow(adapter)
      .to receive(:decode)
      .with('recovery_token')
      .and_return(payload)

    adapter
  end

  let(:params) do
    {
      user_id: 1,
      password: 'password',
      recovery_token: 'recovery_token'
    }
  end

  let(:user) { build(:user, id: 1, password_hash: 'password_hash') }
  let(:updated_user) { build(:user, id: 1, password_hash: 'updated') }
  let(:payload) { { user_id: 1, password_hash: 'password_hash' } }
  let(:password_compare_result) { true }

  before do
    allow(ActiveSupport::SecurityUtils)
      .to receive(:secure_compare)
      .with('password_hash', 'password_hash')
      .and_return(password_compare_result)
  end

  context 'when params are invalid' do
    let(:validation_scheme) { -> (_) { double(success?: false, errors: 'e') } }

    it 'returns Left monad with errors' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('e')
    end
  end

  context 'when recovery_token is invalid' do
    before do
      allow(jwt)
        .to receive(:decode)
        .and_raise(JWT::DecodeError)
    end

    it 'returns Left monad with errors' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when recovery_token is expired' do
    before do
      allow(jwt)
        .to receive(:decode)
        .and_raise(JWT::ExpiredSignature)
    end

    it 'returns Left monad with errors' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when user does not exist' do
    before do
      allow(user_repository)
        .to receive(:find)
        .with(1)
        .and_raise(ActiveRecord::RecordNotFound)
    end

    it 'returns Left monad with errors' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when password hash from token does not match user password_hash' do
    let(:password_compare_result) { false }

    it 'returns Left monad with errors' do
      result = subject.call(params)

      expect(result).to be_left
      expect(result.value[0]).to eq(:unauthorized)
    end
  end

  context 'when all params valid' do
    it 'returns Right monad with updated user' do
      expect(change_password)
        .to receive(:call)
        .with(user: user, password: 'password')

      expect(session_repository)
        .to receive(:delete_sessions)
        .with(user_id: user.id)

      result = subject.call(params)

      expect(result).to be_right
      expect(result.value).to eq(updated_user)
    end
  end
end
