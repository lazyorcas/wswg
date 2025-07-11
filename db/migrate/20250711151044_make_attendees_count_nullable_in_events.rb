class MakeAttendeesCountNullableInEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :events, :attendees_count, true
    change_column_default :events, :attendees_count, nil
  end
end

# UPDATE events
# SET attendees_count = NULL, attendees_count_finalized_at = NULL
# WHERE attendees_count = 0;
