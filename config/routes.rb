Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:create] do
    collection do
      get 'current'
    end
  end

  resource :sessions, only: [:create] do
    member do
      put 'refresh'
    end
  end

  resource :profile, only: [:create]

  resources :categories, only: [:index]
end
