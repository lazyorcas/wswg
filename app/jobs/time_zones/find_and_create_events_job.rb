class TimeZones::FindAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  HOUR_TO_FETCH_EVENTS = 6

  def perform
    TimeZone.includes(:city_sources).find_each do |time_zone|
      next if time_zone.now.hour != HOUR_TO_FETCH_EVENTS

      time_zone.city_sources.find_each do |city_source|
        CitySource::FindAndCreateEventsJob.perform_later(city_source.id)
      end
    end
  end
end
