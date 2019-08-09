Rails.application.routes.draw do

  resources :genres

  get '/search' => 'books#search', :as => 'search_page'
  resources :books do
    collection do
      get :autocomplete
    end
  end
  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations' }
  # devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: "users#index"
  
  resources :users, only: [:show, :update, :destroy]
  # get '/users/address', to: 'users/registrations#address_form', as: 'address_registration'
 
  get '/address' => 'users#address_form', :as => 'address_registration'


end