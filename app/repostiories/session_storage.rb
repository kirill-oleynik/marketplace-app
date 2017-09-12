class SessionStorage
  include Inject[
    redis: 'adapters.redis'
  ]

  def find(id)
    redis.hgetall session_key(id)
  end

  def persist(id, data, lifetime)
    redis.sadd(user_key(data[:user_id]), session_key(id))
    redis.hmset(session_key(id), data)
    redis.expire(session_key(id), lifetime)
  end

  def delete(user_id, *except_ids)
    keys_to_delete = user_sessions_keys(user_id) - session_keys(except_ids)

    keys_to_delete.map { |key| redis.del(key) }
    redis.srem(user_key(user_id), keys_to_delete)
  end

  def exists?(user_id, client_id)
    user_sessions_keys = redis.smembers(user_key(user_id))
    user_sessions_keys.include? session_key(client_id)
  end

  def session_key(id)
    "sess:#{id}"
  end

  def user_key(id)
    "user_sess:#{id}"
  end

  private

  def user_sessions_keys(id)
    redis.smembers user_key(id)
  end

  def session_keys(*ids)
    ids.flatten.map { |id| session_key(id) }
  end
end
