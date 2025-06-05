class HomeController < ApplicationController
  layout "home"

  def index
    load_enabled_cities
    build_search_query

    ahoy.track "Visited homepage"
  end

  def pricing
    load_city

    ahoy.track "Visited pricing page"
  end

  private

  def load_enabled_cities
    @enabled_cities = City.enabled.order(:name)
  end

  def build_search_query
    @search_query = SearchQuery.new
  end

  def load_city
    @city = current_visit&.city || Current.person&.city
  end
end
