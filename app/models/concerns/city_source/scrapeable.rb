module CitySource::Scrapeable
  extend ActiveSupport::Concern

  def scrape
    source.scrape(self)
  end
end
