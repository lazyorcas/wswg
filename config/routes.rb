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

  get "/personalization", to: "home/personalization#index", as: :personalization
  put "/personalize", to: "home/personalization#update", as: :personalize

  get "/:event_category_slug-near-me", to: "home/events#index", time_period_slug: "all", as: :all_nearby_events
  get "/:event_category_slug-near-me-:time_period_slug", to: "home/events#index", as: :nearby_events

  get "/:city_slug-:event_category_slug", to: "home/events#index", time_period_slug: "all", as: :all_city_events, constraints: { event_category_slug: /#{EventCategory::SLUGS.join('|')}/ }
  get "/:event_category_slug-:time_period_slug-in-:city_slug", to: "home/events#index", as: :city_events, constraints: { event_category_slug: /#{EventCategory::SLUGS.join('|')}/ }

  get "/events/:id", to: "home/events#show", as: :event
  get "/events/:id/description", to: "home/events/descriptions#show", as: :event_description
  get "/events/:id/redirect", to: "home/events/redirects#show"

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

  namespace :current_person do
    namespace :settings do
      resources :preferences, only: [ :show, :update ]
    end
  end

  post "/visit/duration_sync", to: "current_visit/duration_sync#create", as: :current_visit_duration_sync

  get "/:city_slug-events-map", to: "map#index", as: :city_map

  get "/map", to: "map#index", as: :map
  namespace :map do
    resources :events, only: [ :index, :show ]
    resources :search_queries, only: [ :index, :create, :show ]

    get "/bookmarks/events", to: "bookmarks/events#index", as: :bookmarked_events
  end

  resources :search_queries, only: [ :create ]
  resources :bookmarks, only: [ :index, :create, :update ]

  resources :events, only: [] do
    resource :bookmark, only: [ :show ], on: :member, module: "events"
  end

  post "/stripe/webhook", to: "stripe#webhook"
end
