class HomeController < ApplicationController
  if Rails.env.production?
    # Mapbox is free for 50,000 requests per month.
    # This rate limit is only for beta testing.
    rate_limit to: 10, within: 1.minute, only: :index, if: -> { Current.user.present? }
  end

  before_action :require_user!

  def index
    build_search
  end

  private

  def build_search
    @search ||= search_scope.build
    @search.attributes = search_params
  end

  def search_scope
    Event::Search.where(user: Current.user)
  end

  def search_params
    search_params = params[:event_search]
    search_params ? search_params.permit(:query) : {}
  end
end
