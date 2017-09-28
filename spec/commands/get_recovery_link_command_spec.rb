require('rails_helper')

RSpec.describe GetRecoveryLinkCommand do
  subject { described_class.new.call(user_id: 1, token: 'token') }

  it 'returns right formatted recover link' do
    expect(subject)
      .to match("#{ENV['WEB_URL']}/password_recovery/1/token")
  end
end
