Rails.application.routes.draw do
  scope "(:locale)", locale: /en|kh/ do
    constraints subdomain: /admin/ do
      namespace :admin, path: "/" do
        get "/login" => "sessions#new"
        get "/logout" => "sessions#destroy"
        post "/login" => "sessions#create", as: :session
        resources :users, only: [:index, :destroy]
        resources :episodes, except: :show
        resources :lessons, except: :show
        
        get '/:locale' => 'episodes#index'
        root "episodes#index"
      end
    end
    
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
        get "trending" => "lessons#trending", on: :collection
      end
      
      resources :episodes, only: :index do
        get "search" => "episodes#search", on: :collection
        get "trending" => "episodes#trending", on: :collection
      end
    end
    
    get '/:locale' => 'home#index'
    root "home#index"
  end
end
