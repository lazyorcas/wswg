module City::Scrapeable
  extend ActiveSupport::Concern

  def scrape(limit)
    limit_per_city_source = limit / city_sources.count

    city_sources.each do |city_source|
      city_source.queue_scrape(limit_per_city_source)
    end
  end
end
