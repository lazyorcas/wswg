class AddNonNullCheckToTimeZoneInEvents < ActiveRecord::Migration[8.0]
  def change
    change_column_null :events, :time_zone_id, false
  end
end
