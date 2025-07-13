class HomeController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper

  layout "home"

  def index
    ahoy.track "Visited homepage"
    load_nearby_city

    if @city.present?
      load_events_page_builder
      build_events
      @events = @events.includes(:source, :location, :city)
    end

    load_events_directory
  end

  def pricing
    head(:gone)

    # ahoy.track "Visited pricing page"
    # load_city
  end

  def local_events_directory
    ahoy.track "Visited local events directory"
    load_events_directory(complete: true)
  end

  private

  def load_nearby_city
    @city = get_city_from_current_city
  end

  def load_city
    @city = get_city_from_current_city || get_city_from_current_person
  end

  def load_events_page_builder
    @events_page_builder = Marketing::EventsPageBuilderFactory.build({
      city: @city,
      event_category: EventCategory.new(:events),
      time_period: TimePeriod.new(@city.time_zone, :all),
      order_by: sort_by
    })
  end

  def build_events
    @events = @events_page_builder.build_events
  end

  def load_events_directory(complete: false)
    @events_directory = events_directory_builder.build_links_attributes(complete: complete)
  end

  def events_directory_builder
    @events_directory_builder ||= Marketing::EventsDirectoryBuilder.new
  end
end
