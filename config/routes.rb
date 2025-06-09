Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  mount MissionControl::Jobs::Engine, at: "/jobs"
  mount FieldTest::Engine, at: "field_test", constraints: AdminConstraint.new
  get "/analytics", to: "analytics#index", as: :analytics

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  get "/local-events-directory", to: "home#local_events_directory", as: :local_events_directory
  get "/pricing", to: "home#pricing", as: :pricing

  get "/events-near-me", to: "home/events#index", time_period_slug: "all", as: :all_nearby_events
  get "/events-near-me-:time_period_slug", to: "home/events#index", as: :nearby_events
  get "/:city_slug-events", to: "home/events#index", time_period_slug: "all", as: :all_city_events
  get "/events-:time_period_slug-in-:city_slug", to: "home/events#index", as: :city_events
  get "/events/:id/redirect", to: "home/events#redirect", as: :event_redirect

  resources :users, only: [ :new, :create ]
  get "/login", to: "sessions#new"
  get "/auth/:provider/callback", to: "omniauth_sessions#create"
  passwordless_for :users, controller: "passwordless_sessions", as: "passwordless", at: "passwordless"

  get "/user/edit", to: "current_user#edit", as: :edit_current_user
  patch "/user", to: "current_user#update", as: :current_user
  get "/user/top_up_credits", to: "current_user#top_up_credits", as: :current_user_top_up_credits

  get "/visitor/edit", to: "current_visitor#edit", as: :edit_current_visitor
  patch "/visitor", to: "current_visitor#update", as: :current_visitor
  get "/top_up_needed", to: "current_person#top_up_needed", as: :top_up_needed

  get "/map", to: "map#index", as: :map
  namespace :map do
    resources :events, only: [ :index, :show ]
    resources :search_queries, only: [ :index, :create, :show ]

    get "/bookmarks/events", to: "bookmarks/events#index", as: :bookmarked_events
  end

  resources :search_queries, only: [ :create ]
  resources :bookmarks, only: [ :create, :update ]

  post "/stripe/webhook", to: "stripe#webhook"
end
