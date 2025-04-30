class AddTimeZoneToCities < ActiveRecord::Migration[8.0]
  def change
    add_column :cities, :time_zone, :string
  end
end

# UPDATE cities
# SET time_zone = time_zones.name
# FROM time_zones
# WHERE cities.time_zone_id = time_zones.id
