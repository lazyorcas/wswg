class ScrapeAndCreateEventsJob < ApplicationJob
  HOUR_TO_FETCH_EVENTS = 6
  NEW_EVENT_LIMIT_PER_CITY_SOURCE = 1_000
  INITIAL_LIMIT_MODIFIER = 0.2
  MAX_LIMIT_MODIFIER = 1.0

  queue_with_priority 2

  def perform
    City.includes(:city_sources).find_each do |city|
      next if city.time_zone.current_hour != HOUR_TO_FETCH_EVENTS

      city.city_sources.find_each do |city_source|
        next unless city_source.enabled?

        limit_modifier = calculate_limit_modifier(city, city_source)
        limit = (limit_modifier * NEW_EVENT_LIMIT_PER_CITY_SOURCE).floor
        next if limit.zero?

        CitySource::ScrapeAndCreateEventsJob.perform_later(city_source.id, limit: limit)
      end
    end
  end

  private

  def calculate_limit_modifier(city, city_source)
    return INITIAL_LIMIT_MODIFIER if city_source.last_fetched_at.nil?

    [ MAX_LIMIT_MODIFIER, city.current_score ].min
  end
end
