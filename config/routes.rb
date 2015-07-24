Rails.application.routes.draw do
  constraints subdomain: /admin/ do
    namespace :admin, path: "/" do
      root "episodes#index"
      get "/login" => "sessions#new"
      get "/logout" => "sessions#destroy"
      post "/login" => "sessions#create", as: :session
      resources :episodes, except: :show
      resources :lessons, except: :show
    end
  end
  
  root "home#index"
  
  get "/register" => "users#new"
  get "/login" => "sessions#new"
  get "/logout" => "sessions#destroy"
  get "/account_activate" => "accounts#activate"
  post "/login" => "sessions#create", as: :session
  
  get "/password_resets/edit" => "password_resets#edit"
  post "/password_resets/update" => "password_resets#update", as: :update_password
  resources :password_resets, only: [:new, :create]

  get "/account" => "users#edit"
  resources :users, only: [:new, :create]
  
  resources :episodes, only: :index
  resources :lessons, only: [:index] do
    resources :episodes, only: [:index, :show]
  end

  namespace :api do
    get "users/validate" => "users#validate"
    post "users/update" => "users#update"
    
    resources :comments, only: [:index, :create]
    
    resources :lessons, only: :index do
      get "search" => "lessons#search", on: :collection
    end
    
    resources :episodes, only: :index do
      get "search" => "episodes#search", on: :collection
    end
  end
end
