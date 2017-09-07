require_relative 'environment'

tmp_dir = File.join(Rails.root, 'tmp')

env = ActiveSupport::StringInquirer.new(ENV.fetch('RAILS_ENV') { 'development' })
environment env.to_s

threads_count = ENV.fetch('RAILS_THREADS_COUNT') { 5 }
threads threads_count, threads_count

workers_count = ENV.fetch('RAILS_WORKERS_COUNT') { 1 }
workers workers_count

pidfile File.join(tmp_dir, 'pids', 'server.pid')
state_path File.join(tmp_dir, 'pids', 'puma.state')
stdout_redirect File.join(Rails.root, 'log', 'puma.log')

if env.production?
  bind "unix://#{File.join(tmp_dir, 'sockets', 'puma.sock')}"
else
  port ENV.fetch('PORT') { 3000 }
end

preload_app!

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end

plugin :tmp_restart
