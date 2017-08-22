class RedisAdapter
  def set(key, value)
    connection.set(key, value)
  end

  def expire(key, exp)
    connection.expire(key, exp)
  end

  def exists(value)
    connection.exists(value)
  end

  private

  def connection
    @connection ||= Redis.current
  end
end
