class Source < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :template_url, presence: true
  validates :scraper_type, presence: true, inclusion: { in: %w[ BrowserScraper ApiScraper ] }
end
