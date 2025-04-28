class MoveTimeZoneToTimeZoneIdInCities < ActiveRecord::Migration[8.0]
  def change
    remove_column :cities, :time_zone
    add_reference :cities, :time_zone, foreign_key: true
  end
end
