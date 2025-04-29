class RemoveTimeZoneFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_reference :events, :time_zone, foreign_key: true
  end
end
