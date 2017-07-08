Rails.application.routes.draw do
  root "static_pages#index"
  devise_scope :user do
    get "profile", to: "registrations#edit"
  end
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users do
    member do
      get :following, :followers
      get :posts, to: "posts#index"
    end
  end

  resources :posts, except: [:index, :new, :edit] do
    resources :comments, except: [:new]
  end
  resources :relationships, only: [:create, :destroy]
  resources :tags do
    get :posts
  end
end
