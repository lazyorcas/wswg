class CitySource::Scrapeable::ScrapeAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3

  def perform(id, limit:)
    city_source = CitySource.find(id)
    city_source.scrape(limit)
  end
end
