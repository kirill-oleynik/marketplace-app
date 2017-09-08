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

  resources :categories, only: [:index]
end
