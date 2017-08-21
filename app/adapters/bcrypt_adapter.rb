class BcryptAdapter
  COST = 12

  def encode(secret, cost: COST)
    BCrypt::Password.create(secret, cost: cost)
  end

  def encode_with_salt(secret, password_hash)
    salt = BCrypt::Password.new(password_hash).salt
    BCrypt::Engine.hash_secret(secret, salt)
  end
end
