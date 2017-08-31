Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:create]

  resource :session, only: [:update]
  resources :sessions, only: [:create]

  resource :profile, only: [:create]
end
