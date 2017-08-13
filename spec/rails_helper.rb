ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'database_cleaner'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.prepend_before :each, with_db_cleaner: true do
    DatabaseCleaner.clean_with :truncation, except: ['ar_internal_metadata']
    DatabaseCleaner.start
  end

  config.append_after :each, with_db_cleaner: true do
    DatabaseCleaner.clean
  end
end
