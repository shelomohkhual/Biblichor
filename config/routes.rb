Rails.application.routes.draw do

  resources :payments, :only => [:new, :create]

  # get 'payment#new', as: :new__payment 

  get '/genre/:genre', to: 'books#index', as: :genre
  get '/genre/', to: 'books#index', as: :all_genre

 

  namespace :admin do
      resources :users

      root to: "users#index"
    end

  # resources :genres
  resources :books, :except => [:index]
  resources :reviews, :except => [:create]
  post '/books/:id', to: 'reviews#create', as: :add_review
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: "users#index"
  
  resources :users, only: [:show, :update, :destroy]
  # get '/users/address', to: 'users/registrations#address_form', as: 'address_registration'

  # Books search
  get '/search' => 'books#search', :as => 'search_page'

  get '/cart' => 'users#cart', :as => 'cart'
  get '/cart/:book' => 'users#add_cart', :as => 'add_cart'
  delete '/cart/:book' => 'users#remove_cart', :as => 'remove_cart'
  
  get '/address' => 'users#address_form', :as => 'address_form'
  post '/address' => 'users#create_address', :as => 'create_address'


end