Rails.application.routes.draw do

  namespace :admin do
      resources :users
      resources :genres
      resources :books

      root to: "users#index"
    end

  resources :genres
  resources :books
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: "users#index"
  
  resources :users, only: [:show, :update, :destroy]
  # get '/users/address', to: 'users/registrations#address_form', as: 'address_registration'

  # Books search
  get '/search' => 'books#search', :as => 'search_page'
  
  get '/address' => 'users#address_form', :as => 'address_form'
  post '/address' => 'users#create_address', :as => 'create_address'


end