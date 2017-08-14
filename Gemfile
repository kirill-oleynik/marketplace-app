source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails'
gem 'pg'
gem 'puma'
gem 'bcrypt'

gem 'dry-types'
gem 'dry-struct'
gem 'dry-monads'
gem 'dry-matcher'

group :development do
  gem 'listen'
end

group :test do
  gem 'fuubar'
  gem 'rspec-rails'
  gem 'database_cleaner'
end

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'awesome_print'
  gem 'factory_girl_rails'
end
