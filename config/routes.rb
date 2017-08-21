Rails.application.routes.draw do
  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
