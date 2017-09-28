require('rails_helper')

RSpec.describe GetRecoveryLinkCommand do
  subject { described_class.new.call('token') }

  it 'returns right formatted recover link' do
    expect(subject)
      .to match("#{ENV['WEB_URL']}/password_recovery/token")
  end
end
