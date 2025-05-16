class HomeController < ApplicationController
  layout "home"

  def index
    load_enabled_cities
  end

  def pricing
    ahoy.track("Visited pricing page")
  end

  private

  def load_enabled_cities
    @enabled_cities = City.enabled.order(:name)
  end
end
