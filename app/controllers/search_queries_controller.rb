class SearchQueriesController < ApplicationController
  before_action :require_user!

  def index; end

  def create
    build_search_query
    @search_query.save!
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
