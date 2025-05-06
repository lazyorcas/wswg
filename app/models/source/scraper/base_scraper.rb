class Source::Scraper::BaseScraper
  DEV_MAX_PAGE_COUNT = 2

  attr_reader :source, :strategy

  def initialize(source, strategy: nil)
    @source = source
    @strategy = strategy || source.strategy_class.new
  end

  def find_events_from_city_source(city_source)
    raise NotImplementedError
  end

  def max_page_count
    Rails.env.production? ? strategy.max_page_count : DEV_MAX_PAGE_COUNT
  end
end
