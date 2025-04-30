class AddScraperTypeToSources < ActiveRecord::Migration[8.0]
  def change
    add_column :sources, :scraper_type, :string
  end
end

# Source.update_all(scraper_type: "BrowserScraper")
