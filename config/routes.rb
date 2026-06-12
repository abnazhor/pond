Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  mount SolidErrors::Engine, at: "/errors" if Rails.env.production?
  mount MissionControl::Jobs::Engine, at: "/jobs"

  root "application#root"

  resource :feed

  resources :users, path: "/", constraints: { id: /@[^\/]+/ } do
    post :follow, on: :member
    delete :unfollow, on: :member

    resources :collections, path: "/", constraints: { id: /\d+/ }
  end

  resources :pins do
    get :url_images, on: :collection
    patch :update_collection, on: :member
    get :secondary_actions, on: :member
  end

  resources :posts, only: [ :new, :create ] do
    resource :pins, only: [ :new, :create, :show ]
  end

  resources :collections, only: [ :create, :update, :destroy ] do
    resource :pins, only: [ :new, :create, :show ]
  end

  get :join, to: "sessions#new"
  post :join, to: "sessions#create"
  post "join/verify_auth_code", to: "sessions#verify_auth_code", as: :verify_auth_code
  delete :sign_out, to: "sessions#destroy"
end
