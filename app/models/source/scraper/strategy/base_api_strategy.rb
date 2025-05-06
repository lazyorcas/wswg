class Source::Scraper::Strategy::BaseApiStrategy < Source::Scraper::Strategy::BaseStrategy
  def fetch_city_source(city_source, page_index:)
    raise NotImplementedError
  end

  def get_events_attributes(response, &block)
    raise NotImplementedError
  end

  def has_more_pages?(response)
    raise NotImplementedError
  end
end
