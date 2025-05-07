module City::Scrapeable
  extend ActiveSupport::Concern

  def scrape(limit)
    city_sources.each do |city_source|
      city_source.queue_scrape(limit)
    end
  end
end
