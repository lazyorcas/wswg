class Source::Scraper::Strategy::ApiBaseStrategy < Source::Scraper::Strategy::BaseStrategy
  def fetch_city_source(city_source, page_index:)
    raise NotImplementedError
  end

  def add_event_urls(response, &block)
    raise NotImplementedError
  end

  def has_more_pages?(response)
    raise NotImplementedError
  end
end
