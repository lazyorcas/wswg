class AddAttendeesCountToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :attendees_count, :integer
  end
end
