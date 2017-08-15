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
end
