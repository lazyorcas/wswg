class SearchQueriesController < ApplicationController
  include FieldTestHelper
  include CityDetection
  # include CreditsCheck

  rate_limit to: 20,
    within: 1.minute,
    only: [ :create ],
    with: -> do
      Sentry.capture_message("Too many requests.", level: :warning)
      redirect_to(root_path, flash: { error: "Too many requests. Please wait a moment and try again." })
    end

  # require_credits only: [ :create ]

  def create
    build_search_query

    ahoy.track "Searched", query: @search_query.query, source: request.referer

    begin
      assign_city_to_search_query
      if @search_query.city.nil?
        respond_to_city_not_found and return
      end

      @search_query.save!
      redirect_to(map_path(search_query_id: @search_query.id))

    rescue => e
      Sentry.capture_exception(e)
      error_message = e.is_a?(City::NotSupportedError) ? e.message : "Failed to search."
      redirect_to(root_path, flash: { error: error_message })
    end
  end

  private

  def build_search_query
    @search_query ||= search_query_scope.build
    @search_query.attributes = search_query_params
  end

  def assign_city_to_search_query
    @search_query.city = get_city_from_search_query ||
      get_city_from_search_query_params ||
      get_city_from_current_city ||
      get_city_from_current_person
  end

  def get_city_from_search_query
    city_name = get_city_name_from_query(@search_query.query)
    if city_name == "NOT_SUPPORTED"
      raise City::NotSupportedError.new(@search_query.query)
    end
    City.find_by_name(city_name)
  end

  def get_city_from_search_query_params
    City.find_by_id(@search_query.city_id)
  end

  def search_query_scope
    SearchQuery.where(searcher: Current.person)
  end

  def search_query_params
    search_query_params = params[:search_query]
    search_query_params ? search_query_params.permit(:query, :city_id) : {}
  end
end
