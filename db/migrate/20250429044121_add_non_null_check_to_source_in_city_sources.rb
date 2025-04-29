class AddNonNullCheckToSourceInCitySources < ActiveRecord::Migration[8.0]
  def change
    change_column_null :city_sources, :source_id, false
  end
end
