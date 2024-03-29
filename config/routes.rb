require 'sidekiq/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:create]

  resource :user, only: [] do
    resource :password_recovery,
             only: [:create, :update],
             controller: :password_recovery
  end

  resource :current_user, only: [:show, :update] do
    member do
      put :password
    end
  end

  resource :sessions, only: [:create, :destroy] do
    member do
      put 'refresh'
    end
  end
  get '/auth/failure', to: 'oauth_callbacks#failure'
  get '/auth/linkedin/callback', to: 'oauth_callbacks#linkedin'

  resource :profile, only: [:create]

  resources :categories, only: [:show, :index]

  resources :applications, param: :slug, only: [:show] do
    resource :gallery, only: [:show]
    resource :rating, only: [:show]
  end

  resources :applications, only: [] do
    resources :favorites, only: [:create]
  end

  resources :application_candidates, only: [:create]

  resources :favorites, only: [:index, :destroy]

  resources :reviews, only: [:create, :destroy]

  resources :search, only: [:index]

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
