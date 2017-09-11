class SessionStorage
  def initialize(storage_client)
    @storage_client = storage_client
  end

  def persist(id, data, lifetime)
    storage_client.sadd(user_key(data[:user_id]), session_key(id))
    storage_client.hmset(session_key(id), data)
    storage_client.expire(session_key(id), lifetime)
  end

  def session_key(id)
    "sess:#{id}"
  end

  def user_key(id)
    "user_sess:#{id}"
  end

  private

  attr_reader :storage_client
end
