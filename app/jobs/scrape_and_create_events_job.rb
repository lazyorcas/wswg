# June 3rd 2025, each event's markdown has ~4000 tokens.
# OpenAI gives 2.5M daily free credits.
# 2.5M / 4000 = 625 free events per day.

class ScrapeAndCreateEventsJob < ApplicationJob
  HOUR_TO_FETCH_EVENTS = 0
  EVENT_LIMIT_PER_CITY_SOURCE = 1_000
  INITIAL_LIMIT_MODIFIER = 0.2
  MIN_LIMIT_MODIFIER = 0.05
  MAX_LIMIT_MODIFIER = 1.0

  queue_as :default
  queue_with_priority 0

  def perform
    City.enabled.includes(:city_sources).find_each do |city|
      next if city.time_zone.current_hour != HOUR_TO_FETCH_EVENTS

      city.city_sources.find_each do |city_source|
        next unless city_source.enabled?

        limit_modifier = calculate_limit_modifier(city, city_source)
        limit = (limit_modifier * EVENT_LIMIT_PER_CITY_SOURCE).floor

        CitySource::ScrapeAndCreateEventsJob.perform_later(city_source.id, limit: limit)
      end
    end
  end

  private

  def calculate_limit_modifier(city, city_source)
    return INITIAL_LIMIT_MODIFIER if city_source.last_fetched_at.nil?

    [ MIN_LIMIT_MODIFIER, [ MAX_LIMIT_MODIFIER, city.current_score ].min ].max
  end
end
