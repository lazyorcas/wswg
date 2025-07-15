class Home::EventsController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper
  include Events

  layout "home"

  after_action :add_event_to_seen_events, only: [ :show ], if: -> { Current.person.persisted? }

  helper_method :nearby?

  def index
    load_city
    if @city.nil?
      if nearby?
        respond_to_city_not_found
      else
        head(:not_found)
      end
      return
    end

    load_event_category
    load_time_period

    build_events
    eager_load_events_associations

    if sort_by_interests?
      limit_events_to_batch_size
      build_next_personalized_event_batch_path

    elsif Current.person.persisted?
      split_events_into_batches
    end

    build_meta_title
    build_meta_description
    build_title
    build_description
    build_alternate_links_attributes
    build_map_path

    ahoy.track "Viewed events", city: @city.name, event_category: @event_category.name, time_period: @time_period.name, nearby: nearby?
  end

  def show
    load_event

    ahoy.track "Viewed event", event_id: @event.id, source: params[:source], sort_by: sort_by
  end

  private

  def nearby?
    @is_nearby ||= params[:city_slug].blank?
  end

  def load_city
    @city = nearby? ? get_city_from_current_city : get_city_from_params
  end

  def event_category_symbol
    EventCategory::SLUG_TO_SYMBOL_MAPPING[params[:event_category_slug]]
  end

  def time_period_symbol
    TimePeriod::SLUG_TO_SYMBOL_MAPPING[params[:time_period_slug]]
  end

  def load_event
    @event = Event.find(params[:id])
  end

  def add_event_to_seen_events
    Person::AddEventToSeenEventsJob.perform_later(
      person_type: Current.person.class.name,
      person_id: Current.person.id,
      event_id: @event.id
    )
  end
end
