# In April 2025, 75M tokens (20_000 requests) costed S$20.
# ---
# 25 cities
# 4 city sources per city
# 1_000 events per city source per month
# 500 tokens per event
# -> 25 * 4 * 1_000 = 100_000 events / requests
# ---
# Per month, it will cost $100.
# -> It's $4 per city or $1 per city source.

class Cities::ScrapeAndCreateEventsJob < ApplicationJob
  HOUR_TO_FETCH_EVENTS = 6
  NEW_EVENT_LIMIT_PER_CITY_SOURCE = 1_000
  INITIAL_LIMIT_MODIFIER = 0.2
  CITY_SOURCE_FRESH_TIME_WINDOW = 7.days
  MAX_LIMIT_MODIFIER = 1.0

  queue_with_priority 2

  def perform
    City.includes(:city_sources).find_each do |city|
      next if city.time_zone.current_hour != HOUR_TO_FETCH_EVENTS

      city.city_sources.find_each do |city_source|
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

    city_limit_modifier = city.current_score
    city_source_limit_modifier =
      (city_source.last_fetched_at - CITY_SOURCE_FRESH_TIME_WINDOW.ago).abs / CITY_SOURCE_FRESH_TIME_WINDOW

    Math.min(MAX_LIMIT_MODIFIER, city_limit_modifier * city_source_limit_modifier)
  end
end
