Rails.application.routes.draw do
  root "static_pages#index"
  devise_scope :user do
    get "profile", to: "registrations#edit"
  end
  devise_for :users, controllers: {registrations: "registrations"}
  resources :users, only: :show do
    member do
      get :following, :followers
    end
  end
end
