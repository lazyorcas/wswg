class Source < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :template_url, presence: true

  validates :scraper_type, presence: true, inclusion: { in: %w[ BrowserScraper ApiScraper ] }
  validates :strategy_class, presence: true

  def scraper_class
    @scraper_class ||= "Source::Scraper::#{scraper_type}".constantize
  rescue NameError
    nil
  end

  def strategy_class
    @strategy_class ||= "Source::Scraper::Strategy::#{name}".constantize
  rescue NameError
    nil
  end
end
