class AddLatLonIndexToLocations < ActiveRecord::Migration[8.0]
  def change
    add_index :locations, [ :lat, :lon ]
  end
end
