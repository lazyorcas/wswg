class MapController < ApplicationController
  include CityLocatable

  rate_limit to: 10,
    within: 1.minute,
    only: :index,
    with: -> do
      Sentry.capture_message("Too many requests.", level: :warning)
      redirect_to(root_path, status: :temporary_redirect, flash: { error: "Too many requests. Please wait a moment and try again." })
    end

  before_action :require_city!, unless: -> { params[:search_query_id].present? }

  def index
    if params[:search_query_id].present?
      @content_path = map_search_query_path(id: params[:search_query_id])
    end

    @content_path ||= map_search_queries_path(city_id: @city.id)

    ahoy.track "Visited map page"
  end
end
