class JwtAdapter
  SECRET_BASE = ENV['SECRET_KEY_BASE']
  ALGORITHM = 'HS512'.freeze

  def encode(payload)
    JWT.encode(payload, SECRET_BASE, ALGORITHM)
  end

  def decode(token)
    JWT.decode(token, SECRET_BASE, true, algorithm: ALGORITHM)
  end
end
