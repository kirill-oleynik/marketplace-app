class SessionStorage
  def initialize(storage_client)
    @storage_client = storage_client
  end

  def persist(id, data, lifetime)
    storage_client.sadd(user_key(data[:user_id]), session_key(id))
    storage_client.hmset(session_key(id), data)
    storage_client.expire(session_key(id), lifetime)
  end

  def delete(user_id, *except_ids)
    keys_to_delete = user_sessions_keys(user_id) - session_keys(except_ids)

    keys_to_delete.map { |key| storage_client.del(key) }
    storage_client.srem(user_key(user_id), keys_to_delete)
  end

  def exists?(user_id, client_id)
    user_sessions_keys = storage_client.smembers(user_key(user_id))
    user_sessions_keys.include? session_key(client_id)
  end

  def session_key(id)
    "sess:#{id}"
  end

  def user_key(id)
    "user_sess:#{id}"
  end

  private

  attr_reader :storage_client

  def user_sessions_keys(id)
    storage_client.smembers user_key(id)
  end

  def session_keys(*ids)
    ids.flatten.map { |id| session_key(id) }
  end
end
