require_relative 'boot'

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    config.api_only = true
    config.load_defaults 5.1
    config.secret_key_base = ENV['SECRET_KEY_BASE']
    config.autoload_paths << Rails.root.join('lib')
  end
end