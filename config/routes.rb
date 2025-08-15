Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  constraints AdminConstraint.new do
    mount MissionControl::Jobs::Engine, at: "jobs"
    mount FieldTest::Engine, at: "field_test"
    mount Blazer::Engine, at: "blazer"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  get "/local-events-directory", to: "home#local_events_directory", as: :local_events_directory

  scope to: "home/events#index" do
    scope event_category_slug: "events" do
      get "/:city_slug-events", time_period_slug: "all", as: :all_city_events
      get "/events-:time_period_slug-in-:city_slug", time_period_slug: TimePeriodConstraint::REGEX, as: :city_events
    end

    scope event_category_slug: EventCategoryConstraint::REGEX do
      get "/:city_slug-:event_category_slug", time_period_slug: "all", as: :all_city_search_query_events
      get "/:event_category_slug-:time_period_slug-in-:city_slug", time_period_slug: TimePeriodConstraint::REGEX, as: :city_search_query_events
    end

    scope event_category_slug: "events" do
      get "/events-near-me", time_period_slug: "all", as: :all_nearby_events
      get "/events-near-me-:time_period_slug", time_period_slug: TimePeriodConstraint::REGEX, as: :nearby_events
    end

    scope event_category_slug: EventCategoryConstraint::REGEX do
      get "/:event_category_slug-near-me", time_period_slug: "all", as: :all_nearby_search_query_events
      get "/:event_category_slug-near-me-:time_period_slug", time_period_slug: TimePeriodConstraint::REGEX, as: :nearby_search_query_events
    end
  end

  get "/events/:id/redirect", to: "home/events/redirects#show"

  resources :users, only: [ :new, :create ]
  get "/login", to: "sessions#new"
  get "/auth/:provider/callback", to: "omniauth_sessions#create"
  passwordless_for :users, controller: "passwordless_sessions", as: "passwordless", at: "passwordless"

  get "/user/edit", to: "current_user#edit", as: :edit_current_user
  patch "/user", to: "current_user#update", as: :current_user

  get "/visitor/edit", to: "current_visitor#edit", as: :edit_current_visitor
  patch "/visitor", to: "current_visitor#update", as: :current_visitor
  # get "/top_up_needed", to: "current_person#top_up_needed", as: :top_up_needed

  namespace :current_person do
    namespace :settings do
      resources :preferences, only: [ :show, :update ]
    end
  end

  post "/visit/duration_sync", to: "current_visit/duration_sync#create", as: :current_visit_duration_sync

  get "/:city_slug-events-map", to: "map#index", as: :city_map

  get "/map", to: "map#index", as: :map
  namespace :map do
    resources :events, only: [ :show ]
    resources :search_queries, only: [ :create ]
  end

  put "/impressions", to: "impressions#create", as: :impression
  put "/seens", to: "seens#create", as: :seen
  resource :recommendation_batch, only: [ :show ]

  resources :search_queries, only: [ :create ]

  resource :business, only: [ :show ] do
    scope module: "businesses" do
      resources :events, only: [ :index ]
      resources :bookmarks, only: [ :index ]
      resources :organizers, only: [] do
        resource :bookmark, only: [ :create, :show, :destroy ], module: "organizers"
      end
    end
  end

  # post "/stripe/webhook", to: "stripe#webhook"
end
