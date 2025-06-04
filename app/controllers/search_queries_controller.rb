class SearchQueriesController < ApplicationController
  include CreditsCheck

  rate_limit to: 20,
    within: 1.minute,
    with: -> do
      Sentry.capture_message("Too many requests.", level: :warning)
      redirect_to(map_path, flash: { error: "Too many requests. Please wait a moment and try again." })
    end

  before_action :require_city!
  require_credits

  def create
    build_search_query
    begin
      @search_query.save!
      redirect_to(map_path(search_query_id: @search_query.id))
    rescue => e
      Sentry.capture_exception(e)
      redirect_to(map_path, flash: { error: "Failed to search." })
    end
  end

  private

  def build_search_query
    @search_query ||= search_query_scope.build
    @search_query.attributes = search_query_params
  end

  def search_query_scope
    SearchQuery.where(searcher: Current.person)
  end

  def search_query_params
    search_query_params = params[:search_query]
    search_query_params ? search_query_params.permit(:query) : {}
  end
end
