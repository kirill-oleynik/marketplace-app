require('rails_helper')

RSpec.describe GetOauthRedirectUrlCommand do
  subject do
    described_class.new.call(foo: 'bar')
  end

  it 'returns right formatted recover link' do
    expect(subject)
      .to match("#{ENV['WEB_URL']}/oauth/callback?foo=bar")
  end
end
