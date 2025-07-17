class MapController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper
  include Events

  rate_limit to: 20,
    within: 1.minute,
    only: [ :index ],
    with: -> do
      redirect_to(root_path, flash: { error: "Too many requests. Please wait a moment and try again." })
    end

  helper_method :search_query?

  def index
    if search_query?
      load_search_query
      load_search_query_events
      load_city

    else
      load_city
      return respond_to_city_not_found if @city.nil?

      load_event_category
      load_time_period

      build_events
      eager_load_events_associations

      if sort_by_interests?
        limit_events_to_batch_size
        build_recommendation_batch_path
      end

      build_search_query
    end

    ahoy.track "Visited map page", city: @city.name
  end

  private

  def recommendation_batch_render_mode
    "map_list"
  end

  def already_recommended_event_ids
    @events.pluck(:id)
  end

  def load_city
    @city = if search_query?
      @search_query.city
    else
      get_city_from_params ||
        get_city_from_current_city ||
        get_city_from_current_person
    end
  end

  def event_category_symbol
    :events
  end

  def time_period_symbol
    :all
  end

  def search_query?
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
end
