Rails.application.routes.draw do
  resources :products
  # resources :products, only: [:index, :show]
  resources :addresses, only: [:new, :create, :edit, :update, :destroy, :index] do
    member do
      get :details
    end
  end
  resource :cart, only: [:show] do
    post "checkout", to: "carts#checkout", as: :checkout
  end
  resources :cart_items, only: [:create, :destroy] do
    patch :update_quantity, on: :member 
  end
  resources :orders, only: [:new, :create, :show, :index] do
    member do
      get "payment"
    end
  end
  devise_for :users
  # get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root to: "home#index"
end
