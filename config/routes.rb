Rails.application.routes.draw do
  root "home#index"
  
  get "/register" => "users#new"
  get "/login" => "sessions#new"
  get "/logout" => "sessions#destroy"
  get "/account_activate" => "accounts#activate"
  post "/login" => "sessions#create", as: :session
  
  get "/password_resets/edit" => "password_resets#edit"
  post "/password_resets/update" => "password_resets#update", as: :update_password
  resources :password_resets, only: [:new, :create]

  resources :users, except: [:index, :destroy]
  
  resources :episodes

  namespace :api do
    get "users/validate" => "users#validate"
    get "episodes/search" => "episodes#search"
    resources :episodes, only: :index
  end
end
