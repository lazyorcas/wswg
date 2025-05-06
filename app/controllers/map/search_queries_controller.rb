class Map::SearchQueriesController < ApplicationController
  include UserCreditsCheck

  before_action :require_user!
  require_credits only: :create

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

  private

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
