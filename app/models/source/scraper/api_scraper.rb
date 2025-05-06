class Source::Scraper::ApiScraper < Source::Scraper::BaseScraper
  def find_events_from_city_source(city_source)
    events_attributes = []

    max_page_count.times do |page_index|
      response = strategy.fetch_city_source(city_source, page_index: page_index)

      strategy.get_events_attributes(response) do |event_attributes|
        events_attributes << event_attributes
      end

      break unless strategy.has_more_pages?(response)
    end

    events_attributes.uniq { |event_attributes| event_attributes[:url] }
  end
end
