Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  get "/login", to: "sessions#new"
  get "/auth/:provider/callback", to: "sessions#create"

  resources :events, only: [ :index, :show ]
  resources :search_queries, only: [ :index, :create, :show ]
  resources :seens, only: [ :create ]
  resources :bookmarks, only: [ :create, :update ]
  namespace :bookmarks do
    resources :events, only: [ :index ]
  end

  get "/changelog", to: "changelog#index", as: "changelog"
end
