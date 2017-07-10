Rails.application.routes.draw do
  root "static_pages#index"
  devise_scope :user do
    get "profile", to: "registrations#edit"
  end
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users, only: :show do
    member do
      get :following, :followers
      get :posts, to: "posts#index"
    end
  end

  resources :posts, except: [:index, :new, :edit] do
    resources :comments, except: [:new]
  end
  resources :relationships, only: [:create, :destroy]
  resources :tags, only: :show do
    get :posts
  end

  namespace :admin do
    root "static_pages#index"
    resources :users
  end

  get "search", to: "searchs#index"
end
