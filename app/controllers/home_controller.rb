class HomeController < ApplicationController
  EVENT_LIMIT = 20

  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper

  layout "home"

  def index
    load_nearby_city

    if @city.present?
      load_events
      order_events
      limit_events
      @events = @events.includes(:source, :location, :city)
    end

    load_enabled_cities

    ahoy.track "Visited homepage"

    if browser.bot? && browser.bot.search_engine?
      Sentry.capture_message("[Search Engine] Visited homepage", extra: {
        bot_name: browser.bot.name
      })
    end
  end

  def pricing
    load_city

    ahoy.track "Visited pricing page"
  end

  def local_events_directory
    load_enabled_cities

    ahoy.track "Visited local events directory"
  end

  private

  def load_nearby_city
    @city = get_city_from_current_city
  end

  def load_events
    @events = Event
      .joins(:city)
      .where(city: { id: @city.id })
      .where("CONCAT(start_date, 'T', start_time) >= ?", "#{@city.time_zone.current_date}T#{@city.time_zone.current_time}")
  end

  def order_events
    @events = if sort_by_time?
      @events.order(:start_date, :start_time)
    else
      @events
        .left_joins(:seens)
        .select("events.*, COUNT(DISTINCT seens.id) as seen_count")
        .group("events.id, sources.id, locations.id, city.id")
        .order("seen_count DESC, events.start_date, events.start_time")
    end
  end

  def limit_events
    @events = @events.limit(EVENT_LIMIT)
  end

  def load_city
    @city = get_city_from_current_city || get_city_from_current_person
  end

  def load_enabled_cities
    @enabled_cities = City.enabled.order(:name)
  end
end
