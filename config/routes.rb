Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: "users#index"

  resources :users, only: [:show, :update, :destroy]


end