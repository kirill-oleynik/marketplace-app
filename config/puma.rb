current_dir = File.dirname(__FILE__)
root_dir = File.absolute_path(File.join(current_dir, '..'))
tmp_dir = File.join(root_dir, 'tmp')

env = ENV.fetch('RAILS_ENV') { 'development' }
environment env

threads_count = ENV.fetch('RAILS_THREADS_COUNT') { 5 }
threads threads_count, threads_count

workers_count = ENV.fetch('RAILS_WORKERS_COUNT') { 1 }
workers workers_count

pidfile File.join(tmp_dir, 'pids', 'server.pid')
state_path File.join(tmp_dir, 'pids', 'puma.state')

if env == 'production'
  stdout_redirect File.join(root_dir, 'log', 'puma.log')
  bind "unix://#{File.join(tmp_dir, 'sockets', 'puma.sock')}"
else
  port ENV['PORT']
end

preload_app!

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
