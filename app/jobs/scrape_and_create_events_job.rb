# July 20th 2025, each event's markdown has ~4000 tokens.
# OpenAI gives 2.5M daily free credits.
# 2.5M / 4000 = 625 free events per day.

class ScrapeAndCreateEventsJob < ApplicationJob
  HOUR_TO_FETCH_EVENTS = 0
  NEW_EVENTS_PER_DAY = 1_000
  INITIAL_LIMIT = 100
  MIN_LIMIT = 2

  queue_as :default
  queue_with_priority 0

  def perform
    City.enabled.includes(:city_sources).find_each do |city|
      next if city.time_zone.current_hour != HOUR_TO_FETCH_EVENTS

      city.city_sources.find_each do |city_source|
        next if !city_source.enabled?

        limit = calculate_limit(city, city_source)
        CitySource::ScrapeAndCreateEventsJob.perform_later(city_source.id, limit: limit)
      end
    end
  end

  private

  def calculate_limit_modifier(city, city_source)
    return INITIAL_LIMIT if city_source.last_fetched_at.nil?

    [ MIN_LIMIT, [ max_limit, (city.current_score * max_limit).ceil ].min ].max
  end

  def max_limit
    @max_limit ||= begin
      city_sources_count = CitySource
        .joins(:source)
        .where(enabled: true)
        .where(sources: { scraper_type: "BrowserScraper" })
        .count

      (NEW_EVENTS_PER_DAY / city_sources_count).floor
    end
  end
end
