class DropTimeZones < ActiveRecord::Migration[8.0]
  def change
    remove_reference :cities, :time_zone, index: true, foreign_key: true
    drop_table :time_zones
    change_column_null :cities, :time_zone, false
  end
end
