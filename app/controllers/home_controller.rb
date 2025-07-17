class HomeController < ApplicationController
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper
  include Events

  layout "home"

  def index
    ahoy.track "Visited homepage"

    load_events_directory
    load_nearby_city

    if @city.present?
      load_event_category
      load_time_period

      if sort_by_interests?
        build_recommendation_batch_path
      else
        build_events
        eager_load_events_associations
      end

      build_map_path
    end
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

  def recommendation_batch_render_mode
    "list"
  end

  def load_nearby_city
    @city = get_city_from_current_city
  end

  def event_category_symbol
    :events
  end

  def time_period_symbol
    :all
  end

  def load_events_directory(complete: false)
    @events_directory = events_directory_builder.build_links_attributes(complete: complete)
  end

  def events_directory_builder
    @events_directory_builder ||= Marketing::EventsDirectoryBuilder.new
  end
end
