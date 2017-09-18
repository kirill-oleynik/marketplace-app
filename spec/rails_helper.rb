ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

abort(
  'The Rails environment is running in production mode!'
) if Rails.env.production?

require 'fileutils'
require 'rspec/rails'
require 'database_cleaner'
require 'json_matchers/rspec'

%w[helpers adapters shared_examples].map do |dir|
  Dir[Rails.root.join("spec/support/#{dir}/*.rb")].each { |f| require f }
end

ActiveRecord::Migration.maintain_test_schema!

JsonMatchers.schema_root = File.join('spec', 'support', 'schemes')

FactoryGirl.definition_file_paths = [
  File.join('spec', 'support', 'factories')
]

FactoryGirl.find_definitions

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

JsonMatchers.configure do |config|
  config.options[:strict] = true
end

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include FactoryGirl::Syntax::Methods

  config.include Support::Helpers::Mocks
  config.include Support::Helpers::Authentication

  config.prepend_before :each, with_db_cleaner: true do
    DatabaseCleaner.clean_with :truncation, except: ['ar_internal_metadata']
    DatabaseCleaner.start
  end

  config.append_after :each, with_db_cleaner: true do
    DatabaseCleaner.clean
    Redis.current.flushall
  end

  config.append_after :each, with_redis_cleaner: true do
    Redis.current.flushall
  end

  config.after :suite do
    test_uploads_path = File.join(Rails.root, 'public', 'uploads', 'test')
    FileUtils.rm_rf(test_uploads_path) if Dir.exist?(test_uploads_path)
  end

  if Bullet.enable?
    config.before(:each) do
      Bullet.start_request
    end

    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end
