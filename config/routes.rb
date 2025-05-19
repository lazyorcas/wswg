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
  get "/analytics", to: "analytics#index", as: :analytics

  get "/events-today-in-:city_slug", to: "home/events#index", as: :events_today
  get "/events-tomorrow-in-:city_slug", to: "home/events#index", as: :events_tomorrow
  get "/events-this-week-in-:city_slug", to: "home/events#index", as: :events_this_week
  get "/events-next-week-in-:city_slug", to: "home/events#index", as: :events_next_week
  get "/events/:id/redirect", to: "home/events#redirect", as: :event_redirect

  resources :users, only: [ :new ]

  get "/login", to: "sessions#new"
  get "/auth/:provider/callback", to: "sessions#create"

  get "/user/no_credits", to: "user#no_credits", as: :user_no_credits
  get "/user/top_up_credits", to: "user#top_up_credits", as: :user_top_up_credits

  get "/map", to: "map#index", as: :map
  namespace :map do
    resources :events, only: [ :index, :show ]
    resources :search_queries, only: [ :index, :create, :show ]

    get "/bookmarks/events", to: "bookmarks/events#index", as: :bookmarked_events
  end

  resources :seens, only: [ :create ]
  resources :bookmarks, only: [ :create, :update ]

  post "/stripe/webhook", to: "stripe#webhook"
end
