require 'rails_helper'

RSpec.describe BcryptAdapter do
  subject { BcryptAdapter.new }

  describe '#encode' do
    it 'generates secret hash via BCrypt' do
      secret = 'Hello World'
      secret_hash = subject.encode(secret, cost: 10)

      expect(secret_hash).to match(/^\$2a\$10\$.{53}$/)
    end
  end

  describe '#encode_with_salt' do
    let(:random_string) { SecureRandom.hex(5) }
    let!(:secret) { random_string }
    let!(:password_hash) { subject.encode(random_string) }

    it 'generates secret hash by salt from other hash' do
      expect(
        subject.encode_with_salt(secret, password_hash)
      ).to eq(password_hash)
    end
  end
end
