class AddNonDuplicationIndexToEvents < ActiveRecord::Migration[8.0]
  def change
    add_index :events, [ :start_date, :end_date, :start_time, :end_time, :location_id ]
  end
end
