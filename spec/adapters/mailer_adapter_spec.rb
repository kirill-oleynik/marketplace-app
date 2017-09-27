require('rails_helper')

RSpec.describe MailerAdapter do
  describe '#password_recovery' do
    let(:options) { { foo: 'bar' } }

    it 'sends right messages with arguments to RecoveryMailer' do
      allow(RecoveryMailer)
        .to receive(:recovery_email)
        .and_return(double(deliver_later: true))

      expect(RecoveryMailer)
        .to receive(:recovery_email)
        .with(options)

      subject.password_recovery(options)
    end
  end
end
