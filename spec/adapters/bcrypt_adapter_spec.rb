require 'rails_helper'

RSpec.describe BcryptAdapter do
  subject { BcryptAdapter.new }

  describe '#encode' do
    it 'generates secret hash via BCrypt' do
      secret = 'Hello World'
      secret_hash = subject.encode(secret, cost: 10)

      expect(secret_hash).to match(/^\$2a\$10\$.{53}$/)
    end

    it 'uses passed salt to generate hash' do
      salt = '$2a$10$tFb9ElwQtRyjjv1rz3ewYe'
      secret = 'Hello World'
      secret_hash = subject.encode(secret, salt: salt)

      expect(secret_hash).to start_with('$2a$10$tFb9ElwQtRyjjv1rz3ewYe')
    end
  end

  describe '#compare' do
    describe 'when secret match to hashed secret' do
      it 'returns true' do
        secret = 'Hello World'
        secret_hash = subject.encode(secret)

        expect(
          subject.compare(secret: secret, secret_hash: secret_hash)
        ).to be_truthy
      end
    end

    describe 'when secret not match to hashed secret' do
      it 'returns true' do
        secret = 'Hello World'
        secret_hash = subject.encode('World Hello')

        expect(
          subject.compare(secret: secret, secret_hash: secret_hash)
        ).to be_falsey
      end
    end
  end
end
