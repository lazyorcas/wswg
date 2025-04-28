class AddNonNullCheckToTimeZoneInCities < ActiveRecord::Migration[8.0]
  def change
    change_column_null :cities, :time_zone_id, false
  end
end
