require('rails_helper')

RSpec.describe PasswordRecovery::InitializeInteraction do
  subject(:result) do
    described_class.new(
      user_repository: user_repository,
      validation_scheme: validation_scheme,
      jwt: jwt,
      mailer: mailer,
      get_recovery_link: get_recovery_link
    ).call(params)
  end

  let(:user) { build(:user, id: 1) }
  let(:params) { { email: user.email } }

  let(:validation_scheme) do
    scheme = double('validation_scheme')

    allow(scheme)
      .to receive(:call)
      .with(email: user.email)
      .and_return(
        double('result', success?: validation_success, errors: 'errors')
      )

    scheme
  end

  let(:validation_success) { true }

  let(:user_repository) do
    repository = double('user_repository')

    allow(repository)
      .to receive(:find_by_email!)
      .with(user.email)
      .and_return(user)

    repository
  end

  let(:jwt) { double('jwt', encode: recovery_token) }
  let(:recovery_token) { 'recovery_token' }

  let(:mailer) { double('mailer') }
  let(:get_recovery_link) do
    command = double('get_recovery_link')
    allow(command)
      .to receive(:call)
      .with(user_id: user.id, token: recovery_token)
      .and_return(recovery_link)
    command
  end
  let(:recovery_link) { 'recovery_link' }

  context 'when params are invalid' do
    let(:validation_success) { false }

    it 'returns Left monad with errors' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:invalid)
      expect(result.value[1]).to eq('errors')
    end
  end

  context 'when user does not exist' do
    before do
      allow(user_repository)
        .to receive(:find_by_email!)
        .with(user.email)
        .and_raise(ActiveRecord::RecordNotFound)
    end

    it 'returns Left monad with errors' do
      expect(result).to be_left
      expect(result.value[0]).to eq(:not_found)
      expect(result.value[1][:id]).to eq(user.email)
    end
  end

  context 'when all params are valid' do
    it 'returns Right monad with recovery_token, recovery_url & user' do
      expect(mailer)
        .to receive(:password_recovery)
        .with(user: user, recovery_link: recovery_link)

      expect(result).to be_right
      expect(result.value).to eq(email: user.email)
    end
  end
end
