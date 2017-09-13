require 'sidekiq/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:create]

  resource :current_user, only: [:show, :update] do
    member do
      put :password
    end
  end

  resource :sessions, only: [:create] do
    member do
      put 'refresh'
    end
  end

  resource :profile, only: [:create]

  resources :categories, only: [:show, :index]

  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username_match = ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(username),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_USERNAME'])
    )

    password_match = ActiveSupport::SecurityUtils.secure_compare(
      ::Digest::SHA256.hexdigest(password),
      ::Digest::SHA256.hexdigest(ENV['SIDEKIQ_PASSWORD'])
    )

    username_match & password_match
  end

  mount Sidekiq::Web, at: '/sidekiq'
end
