Rails.application.routes.draw do

  resources :genres
  resources :books
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # devise_for :users, controllers: { registrations: 'users/registrations' }
  

  root to: "users#index"

  resources :users, only: [:show, :update, :destroy]


end