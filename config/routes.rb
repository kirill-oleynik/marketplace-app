Rails.application.routes.draw do
  root 'home#index'

  resources :users, only: [:create, :update] do
    collection do
      get 'current'
    end
  end

  put 'users/current/password', to: 'users#password'

  resource :sessions, only: [:create] do
    member do
      put 'refresh'
    end
  end

  resource :profile, only: [:create]

  resources :categories, only: [:index]
end
