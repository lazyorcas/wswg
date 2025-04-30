class Source::Scraper::BaseScraper
  attr_reader :source, :strategy

  def initialize(source, strategy:)
    @source = source
    @strategy = strategy
  end

  def find_event_urls_from_url(url)
    raise NotImplementedError
  end
end
