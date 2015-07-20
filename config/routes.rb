Rails.application.routes.draw do
  root "home#index"
  
  get "/register" => "users#new"
  get "/login" => "sessions#new"
  get "/account_activate" => "accounts#activate"
  post "/login" => "sessions#create", as: :session
  get "/logout" => "sessions#destroy"

  resources :users, except: [:index, :destroy]

  namespace :api do
    get "users/validate" => "users#validate"
  end
end
