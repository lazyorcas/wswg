class City::ScrapeAndCreateEventsJob < ApplicationJob
  queue_as :scraper
  queue_with_priority 1

  def perform(id, limit:)
    city = City.find(id)

    city.city_sources.find_each do |city_source|
      CitySource::ScrapeAndCreateEventsJob.perform_later(city_source.id, limit: limit)
    end
  end
end
