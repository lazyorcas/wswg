class Home::EventsController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper
  include Events

  layout "home"

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
      build_recommendation_batch_path
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
  end

  private

  def recommendation_batch_render_mode
    "list"
  end

  def already_recommended_event_ids
    @events.pluck(:id)
  end

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
end
