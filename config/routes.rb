Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:create]

  resource :sessions, only: [:create] do
    member do
      put 'refresh'
    end
  end

  resource :profile, only: [:create]
end
