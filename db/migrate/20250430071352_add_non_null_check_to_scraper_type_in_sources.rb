class AddNonNullCheckToScraperTypeInSources < ActiveRecord::Migration[8.0]
  def change
    change_column_null :sources, :scraper_type, false
  end
end
