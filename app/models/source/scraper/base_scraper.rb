class Source::Scraper::BaseScraper
  attr_reader :source, :strategy

  def initialize(source, strategy: nil)
    @source = source
    @strategy = strategy || source.strategy_class.new
  end

  def find_event_urls_from_url(url)
    raise NotImplementedError
  end
end
