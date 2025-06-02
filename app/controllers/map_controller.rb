class MapController < ApplicationController
  rate_limit to: 10,
    within: 1.minute,
    only: :index,
    with: -> { redirect_to(root_path, flash: { error: "Too many requests. Please try again in 1 minute." }) }

  before_action :require_user!
  before_action :require_city!

  def index
    @content_path = params[:search_query_id].present? ?
      map_search_query_path(id: params[:search_query_id]) :
      map_search_queries_path
  end
end
