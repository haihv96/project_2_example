Rails.application.routes.draw do
  root "static_pages#index"
  get "sign_up", to: "users#new"
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :posts, only: [:show, :create, :update, :destroy] do
    member do
      post "load_comment"
    end
    resources :comments, only: [:edit, :create, :update, :destroy]
  end
  resources :relationships, only: [:create, :destroy]
end
