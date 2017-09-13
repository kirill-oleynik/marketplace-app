class SessionRepository
  include Inject[
    redis: 'adapters.redis'
  ]

  def find(session_id)
    redis.hgetall(session_key(session_id))
  end

  def persist(session_id:, data:, lifetime:)
    redis.sadd(user_key(data[:user_id]), session_key(session_id))
    redis.hmset(session_key(session_id), data)
    redis.expire(session_key(session_id), lifetime)
  end

  def delete_sessions(user_id:, exclude_sessions_ids: [])
    excluded_sessions = session_keys(exclude_sessions_ids)
    sessions_to_delete = all_user_sessions(user_id) - excluded_sessions
    sessions_to_delete.map { |session| redis.del(session) }

    redis.srem(user_key(user_id), sessions_to_delete)
  end

  def exists?(user_id:, session_id:)
    all_user_sessions = redis.smembers(user_key(user_id))
    all_user_sessions.include? session_key(session_id)
  end

  def session_key(session_id)
    "sess:#{session_id}"
  end

  def user_key(user_id)
    "user_sess:#{user_id}"
  end

  private

  def all_user_sessions(user_id)
    redis.smembers user_key(user_id)
  end

  def session_keys(*session_ids)
    session_ids.flatten.map { |id| session_key(id) }
  end
end
