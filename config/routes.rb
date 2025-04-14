# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  get "/auth/spotify/callback", to: "users#spotify"

  resources :users, only: [:show, :destroy]

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  get "users/playlist/:id", to: "users#playlist", as: :user_playlist
  get "users/playlist/:id/play", to: "users#play", as: :user_playlist_play

  resources :users do
    member do
      post :play
      post :next_track
      post :pause
    end
  end
end
