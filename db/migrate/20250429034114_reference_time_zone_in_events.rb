class ReferenceTimeZoneInEvents < ActiveRecord::Migration[8.0]
  def change
    add_reference :events, :time_zone, foreign_key: true
  end
end

# UPDATE events
# SET time_zone_id = cities.time_zone_id
# FROM sources
# JOIN cities ON cities.id = sources.city_id
