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
  get "/pricing", to: "home#pricing", as: :pricing

  resources :users, only: [ :new ]

  get "/login", to: "sessions#new"
  get "/auth/:provider/callback", to: "sessions#create"

  get "user/no_credits", to: "user#no_credits", as: :user_no_credits

  get "/map", to: "map#index", as: :map
  namespace :map do
    resources :events, only: [ :index, :show ]
    resources :search_queries, only: [ :index, :create ]

    get "bookmarks/events", to: "bookmarks/events#index", as: :bookmarked_events
  end

  resources :seens, only: [ :create ]
  resources :bookmarks, only: [ :create, :update ]

  post "stripe/webhook", to: "stripe#webhook"
end
