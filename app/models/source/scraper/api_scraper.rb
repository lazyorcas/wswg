class Source::Scraper::ApiScraper < Source::Scraper::BaseScraper
  def find_events_from_city_source(city_source)
    event_urls = []

    page_count.times do |page_index|
      response = strategy.fetch_city_source(city_source, page_index: page_index)

      strategy.add_event_urls(response) do |url|
        event_urls |= [ url ]
      end

      break unless strategy.has_more_pages?(response)
    end

    event_urls.uniq
  end
end
