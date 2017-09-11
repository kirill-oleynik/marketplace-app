class RedisAdapter
  def set(key, value)
    redis { |connection| connection.set(key, value) }
  end

  def get(key)
    redis { |connection| connection.get(key) }
  end

  def del(key)
    redis { |connection| connection.del(key) }
  end

  def expire(key, exp)
    redis { |connection| connection.expire(key, exp) }
  end

  def exists(value)
    redis { |connection| connection.exists(value) }
  end

  def hmset(key, data)
    redis { |connection| connection.hmset(key, *data.to_a.flatten) }
  end

  def hgetall(key)
    redis { |connection| connection.hgetall(key) }
  end

  def sadd(key, *data)
    redis { |connection| connection.sadd(key, data) }
  end

  def srem(key, members)
    redis { |connection| connection.srem(key, members) }
  end

  def smembers(key)
    redis { |connection| connection.smembers(key) }
  end

  private

  def redis
    RedisConnectionPool.with do |connection|
      yield connection
    end
  end
end
