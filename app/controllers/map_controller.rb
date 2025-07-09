class MapController < ApplicationController
  EVENT_LIMIT = 50

  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper

  rate_limit to: 20,
    within: 1.minute,
    only: [ :index ],
    with: -> do
      Sentry.capture_message("Too many requests.", level: :warning)
      redirect_to(root_path, flash: { error: "Too many requests. Please wait a moment and try again." })
    end

  def index
    if params[:search_query_id].present?
      load_search_query
      load_search_query_events
      @city = @search_query.city

    else
      @city = get_city_from_params ||
        get_city_from_current_city ||
        get_city_from_current_person

      return respond_to_city_not_found if @city.nil?

      if @city.persisted?
        load_city_events
      else
        load_nearby_events
      end

      build_search_query
    end

    filter_out_past_events
    order_events
    limit_events
    @events = @events.includes(:source, :location, :city)

    ahoy.track "Visited map page", city: @city.name
  end

  private

  # Search Query
  def build_search_query
    @search_query ||= search_query_scope.build
    @search_query.city_id ||= @city.id
  end

  def load_search_query
    @search_query = search_query_scope.find(params[:search_query_id])
  end

  def load_search_query_events
    @events = Event
      .where(id: @search_query.result.event_ids)
      .in_order_of(:id, @search_query.result.event_ids)
  end

  def load_city_from_search_query
    @city = @search_query.city
  end

  def search_query_scope
    SearchQuery.joins(:city).where(searcher: [ Current.person, nil ])
  end

  # Events
  def load_city_events
    @events = Event.joins(:city_source).where(city_sources: { city_id: @city.id })
  end

  def load_nearby_events
    @events = Event.within(Event::Locatable::MAX_DISTANCE_TO_CITY, origin: @city.coordinates_arr)
  end

  def filter_out_past_events
    @events = @events.where("CONCAT(start_date, 'T', start_time) >= ?", "#{@city.time_zone.current_date}T#{@city.time_zone.current_time}")
  end

  def order_events
    @events = if sort_by_time?
      @events.order(:start_date, :start_time)
    else
      @events
        .left_joins(:seens)
        .select("events.*, COUNT(DISTINCT seens.id) as seen_count")
        .group(events: :id)
        .order("seen_count DESC, events.start_date, events.start_time")
    end
  end

  def limit_events
    @events = @events.limit(EVENT_LIMIT)
  end
end
