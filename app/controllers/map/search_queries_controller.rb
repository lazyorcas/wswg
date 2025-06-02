class Map::SearchQueriesController < ApplicationController
  include UserCreditsCheck

  before_action :require_user!
  before_action :require_city!
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
    load_last_search_query
    if @last_search_query.present? &&
        @last_search_query.created_at > 1.minute.ago &&
        @last_search_query.query == search_query_params[:query]
      head(:ok) and return
    end

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

  def load_last_search_query
    @last_search_query = search_query_scope.order(created_at: :desc).first
  end

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
