class HomeController < ApplicationController
  include CityDetection

  layout "home"

  def index
    ahoy.track "Visited homepage"
  end

  def pricing
    load_city

    ahoy.track "Visited pricing page"
  end

  def local_events_directory
    load_enabled_cities
  end

  private

  def load_enabled_cities
    @enabled_cities = City.enabled.order(:name)
  end

  def load_city
    @city = get_city_from_visit || get_city_from_current_person
  end
end
