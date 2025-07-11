class AddAttendeesCountFinalizedAtToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :attendees_count_finalized_at, :datetime
  end
end

# UPDATE events
# SET attendees_count_finalized_at = updated_at
# FROM cities
# WHERE events.city_id = cities.id
#   AND attendees_count > 0
#   AND CONCAT(start_date, ' ', start_time) < TO_CHAR(NOW() AT TIME ZONE cities.time_zone, 'YYYY-MM-DD HH24:MI:SS')
