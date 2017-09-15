source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails'
gem 'pg'
gem 'puma'
gem 'redis'
gem 'bcrypt'
gem 'jwt'
gem 'sidekiq'
gem 'connection_pool'
gem 'fog-aws'
gem 'carrierwave'

gem 'dry-types'
gem 'dry-struct'
gem 'dry-monads'
gem 'dry-matcher'
gem 'dry-container'
gem 'dry-validation'
gem 'dry-auto_inject'
gem 'dry-transaction', github: 'dry-rb/dry-transaction'

gem 'active_model_serializers'

group :development do
  gem 'listen'
end

group :test do
  gem 'fuubar'
  gem 'bullet'
  gem 'rspec-rails'
  gem 'json_matchers'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
end

group :development, :test do
  gem 'faker'
  gem 'byebug'
  gem 'rubocop'
  gem 'foreman'
  gem 'dotenv-rails'
  gem 'awesome_print'
  gem 'factory_girl_rails'
end
