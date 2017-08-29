class RedisAdapter
  def set(key, value)
    redis { |connection| connection.set(key, value) }
  end

  def expire(key, exp)
    redis { |connection| connection.expire(key, exp) }
  end

  def exists(value)
    redis { |connection| connection.exists(value) }
  end

  def get(key)
    connection.get(key)
  end

  private

  def redis
    RedisConnectionPool.with do |connection|
      yield connection
    end
  end
end
