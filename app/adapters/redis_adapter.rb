class RedisAdapter
  def set(key, value)
    redis_server.set(key, value)
  end

  def expire(key, exp)
    redis_server.expire(key, exp)
  end

  def exists(value)
    redis_server.exists(value)
  end

  def redis_server
    @redis_server ||= Redis.new(url: ENV['REDIS_URL'])
  end
end
