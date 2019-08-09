Rails.application.routes.draw do

  resources :genres
  resources :books
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # devise_for :users, controllers: { registrations: 'users/registrations' }


  # get '/signin', to: 'devise/sessions#new', as: 'new_user_session'
  # post '/signin', to: 'devise/sessions#create', as: 'user_session'
  # delete '/signout', to: 'devise/sessions#destroy', as: 'destroy_user_session'
  # get '/auth/facebook', to: 'users/omniauth_callbacks#passthru', as: 'user_facebook_omniauth_authorize'
  # match '/auth/facebook', to: 'users/omniauth_callbacks#passthru', as: 'user_facebook_omniauth_authorize', via: [:get, :post]
  # match '/auth/facebook/callback', to: 'users/users/omniauth_callbacks#facebook', as: 'user_facebook_omniauth_callback', via: [:get, :post]

  # match ':controller/:action/:id', via: [:get, :post]
  # get '/users/address', to: 'users#address_form', as: 'address_registration'
  # post '/users/address', to: 'users#registered_address', as: 'address_registered'

  root to: "users#index"
  
  resources :users, only: [:show, :update, :destroy]
  # get '/users/address', to: 'users/registrations#address_form', as: 'address_registration'
  
  get '/search' => 'books#search', :as => 'search_page'
  get '/address' => 'users#address_form', :as => 'address_registration'


end