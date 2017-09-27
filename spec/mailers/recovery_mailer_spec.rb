require('rails_helper')

RSpec.describe RecoveryMailer, type: :mailer do
  describe '#recovery_email' do
    let(:mail) do
      described_class.recovery_email(
        user: user,
        recovery_link: recovery_link
      )
    end

    let(:user) { build(:user) }
    let(:recovery_link) { 'recovery_link' }

    it 'sends recovery link to user email' do
      expect(mail.to).to eq([user.email])
      expect(mail.body.encoded).to include(recovery_link)
    end
  end
end
