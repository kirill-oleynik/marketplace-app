module Adapters
  module BcryptAdapterHelpers
    def password_hash(password = SecureRandom.hex(10))
      bcrypt_adapter.encode(password)
    end

    def bcrypt_adapter
      @bcrypt_adapter ||= BcryptAdapter.new
    end
  end
end
