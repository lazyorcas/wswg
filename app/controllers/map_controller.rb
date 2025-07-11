class MapController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper

  rate_limit to: 20,
    within: 1.minute,
    only: [ :index ],
    with: -> do
      Sentry.capture_message("Too many requests.", level: :warning)
      redirect_to(root_path, flash: { error: "Too many requests. Please wait a moment and try again." })
    end

  helper_method :searching?

  def index
    if searching?
      load_search_query
      load_search_query_events
      @city = @search_query.city

    else
      @city = get_city_from_params ||
        get_city_from_current_city ||
        get_city_from_current_person

      return respond_to_city_not_found if @city.nil?

      load_event_category
      load_time_period
      load_order_by
      load_events_page_builder
      build_events

      build_search_query
    end

    ahoy.track "Visited map page", city: @city.name
  end

  private

  # Search Query
  def searching?
    params[:search_query_id].present?
  end

  def build_search_query
    @search_query ||= search_query_scope.build
    @search_query.city_id ||= @city.id
  end

  def load_search_query
    @search_query = search_query_scope.find(params[:search_query_id])
  end

  def load_search_query_events
    @events = Event
      .where(id: @search_query.result&.event_ids)
      .in_order_of(:id, @search_query.result&.event_ids || [])
  end

  def search_query_scope
    SearchQuery.where(searcher: [ Current.person, nil ])
  end

  # Events
  def load_time_period
    @time_period = TimePeriod.new(@city.time_zone, :all)
  end

  def load_event_category
    @event_category = EventCategory.new(:events)
  end

  def load_order_by
    @order_by = sort_by
  end

  def load_events_page_builder
    @events_page_builder ||= Marketing::EventsPageBuilderFactory.build(
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: @order_by
    )
  end

  def build_events
    @events = @events_page_builder.build_events
  end
end
