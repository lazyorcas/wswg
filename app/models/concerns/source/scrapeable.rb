module Source::Scrapeable
  extend ActiveSupport::Concern

  included do
    validates :scraper_type, presence: true, inclusion: { in: %w[ BrowserScraper ApiScraper ] }
    validates :strategy_class, presence: true
  end

  def scrape(city_source)
    scraper = scraper_class.new(self)
    scraper.find_events_from_city_source(city_source)
  end

  def scraper_class
    @scraper_class ||= "Source::Scraper::#{scraper_type}".constantize
  rescue NameError
    nil
  end

  def strategy_class
    @strategy_class ||= "Source::Scraper::Strategy::#{name.capitalize}".constantize
  rescue NameError
    nil
  end
end
