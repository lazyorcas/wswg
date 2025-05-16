class Map::SearchQueriesController < ApplicationController
  include UserCreditsCheck

  before_action :require_user!
  require_credits only: :create

  rate_limit to: 10,
    within: 1.minute,
    only: :create,
    with: -> do
      flash.now[:error] = "Too many requests. Please try again in 1 minute."
      turbo_stream_flash
    end

  def index; end

  def create
    build_search_query
    begin
      @search_query.save!
    rescue => e
      Sentry.capture_exception(e)

      flash.now[:error] = "Failed to search."
      turbo_stream_flash
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

  def search_query_scope
    SearchQuery.where(user: Current.user)
  end

  def search_query_params
    search_query_params = params[:search_query]
    search_query_params ? search_query_params.permit(:query) : {}
  end
end
