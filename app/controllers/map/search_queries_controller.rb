class Map::SearchQueriesController < ApplicationController
  include BotProtection
  include CityDetection
  include CreditsCheck

  protect_from_bots only: [ :index, :show ]

  rate_limit to: 20,
    within: 1.minute,
    only: [ :create ],
    with: -> do
      Sentry.capture_message("Too many requests.", level: :warning)
      flash.now[:error] = "Too many requests. Please wait a moment and try again."
      turbo_stream_flash(status: :too_many_requests)
    end

  before_action :require_city!, only: [ :index ]
  require_credits only: [ :create ]

  def index; end

  def create
    build_search_query

    begin
      assign_city_to_search_query
      if @search_query.city.nil?
        respond_to_city_not_found and return
      end

      @search_query.save!

    rescue => e
      Sentry.capture_exception(e)
      if e.is_a?(City::NotSupportedError)
        flash.now[:error] = e.message
      else
        flash.now[:error] = "Failed to search."
      end
      turbo_stream_flash(status: :unprocessable_entity)
    end
  end

  def show
    load_search_query
    if @search_query.failed?
      flash.now[:error] = "Failed to search."
    end
  end

  private

  def load_search_query
    @search_query = search_query_scope.find(params[:id])
  end

  def build_search_query
    @search_query ||= search_query_scope.build
    @search_query.attributes = search_query_params
  end

  def assign_city_to_search_query
    @search_query.city = get_city_from_search_query ||
      get_city_from_params ||
      get_city_from_visit ||
      get_city_from_current_person
  end

  def get_city_from_search_query
    city_name = get_city_name_from_query(@search_query.query)
    if city_name == "NOT_SUPPORTED"
      raise City::NotSupportedError.new(@search_query.query)
    end
    City.find_by_name(city_name)
  end

  def search_query_scope
    SearchQuery.where(searcher: Current.person)
  end

  def search_query_params
    search_query_params = params[:search_query]
    search_query_params ? search_query_params.permit(:query) : {}
  end
end
