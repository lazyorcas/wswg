class Source::Scraper::Strategy::Ticketmaster < Source::Scraper::Strategy::ApiBaseStrategy
  def self.max_page_count
    10
  end

  def fetch_city_source(city_source, page_index:)
    Ticketmaster.event_search(
      latitude: city_source.city.latitude,
      longitude: city_source.city.longitude,
      radius: Event::Locatable::MAX_DISTANCE_TO_CITY,
      unit: Event::Locatable::DISTANCE_UNIT,
      page: page_index
    )
  end

  def add_event_urls(response, &block)
    response["events"].each do |event|
      url = event["url"]
      yield url
    end
  end

  def has_more_pages?(response)
    response.dig("_links", "next").present?
  end
end
