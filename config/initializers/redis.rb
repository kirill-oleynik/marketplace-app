workers = ENV['RAILS_WORKERS_COUNT'].to_i
threads = ENV['RAILS_THREADS_COUNT'].to_i

size = workers * threads

RedisConnectionPool = ConnectionPool.new(size: size) do
  Redis.new(url: ENV['REDIS_URL'])
end
