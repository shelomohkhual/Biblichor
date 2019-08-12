Rails.application.routes.draw do
  get 'genre/:genre', to: 'books#index', as: :genre

  namespace :admin do
      resources :users

      root to: "users#index"
    end

  # resources :genres
  resources :books, :except => [:index]
  
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: "users#index"
  
  resources :users, only: [:show, :update, :destroy]
  # get '/users/address', to: 'users/registrations#address_form', as: 'address_registration'

  # Books search
  get '/search' => 'books#search', :as => 'search_page'

  get '/cart' => 'users#cart', :as => 'cart'
  
  get '/address' => 'users#address_form', :as => 'address_form'
  post '/address' => 'users#create_address', :as => 'create_address'


end