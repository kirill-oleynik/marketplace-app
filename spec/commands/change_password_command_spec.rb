require('rails_helper')

RSpec.describe ChangePasswordCommand do
  subject do
    described_class.new(
      user_repository: user_repository,
      bcrypt: bcrypt
    )
  end

  let(:user_repository) do
    repository = double('user_repository')

    allow(repository)
      .to receive(:update!)
      .with(1, password_hash: 'password_hash')
      .and_return(updated_user)

    repository
  end

  let(:bcrypt) { double('bcrypt', encode: 'password_hash') }
  let(:params) { { user: user, password: 'password' } }
  let(:user) { build(:user, id: 1) }
  let(:updated_user) { build(:user, password_hash: 'password_hash') }

  it 'updates user with encoded password and returns right monad with user' do
    expect(user_repository)
      .to receive(:update!)
      .with(user.id, password_hash: 'password_hash')

    result = subject.call(params)

    expect(result).to be_right
    expect(result.value).to eq(updated_user)
  end
end
