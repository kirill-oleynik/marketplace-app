class BcryptAdapter
  COST = 12

  def encode(secret, cost: COST)
    BCrypt::Password.create(secret, cost: cost)
  end
end
