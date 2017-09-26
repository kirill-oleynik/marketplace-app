class JwtAdapter
  SECRET_BASE = ENV['SECRET_KEY_BASE']
  ALGORITHM = 'HS512'.freeze

  def encode(payload, signature = '')
    JWT.encode(payload, secret(signature), ALGORITHM)
  end

  def decode(token, signature = '')
    JWT.decode(
      token, secret(signature), true, algorithm: ALGORITHM
    )
  end

  private

  def secret(signature)
    SECRET_BASE + signature
  end
end
