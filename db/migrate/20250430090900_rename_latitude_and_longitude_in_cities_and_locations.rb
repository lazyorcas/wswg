class RenameLatitudeAndLongitudeInCitiesAndLocations < ActiveRecord::Migration[8.0]
  def change
    rename_column :cities, :latitude, :lat
    rename_column :cities, :longitude, :lon

    rename_column :locations, :latitude, :lat
    rename_column :locations, :longitude, :lon
  end
end
