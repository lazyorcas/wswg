class AddStartDateTimeToEvents < ActiveRecord::Migration[8.0]
  def up
    add_column :events, :start_date_time, :virtual,
      type: :string,
      as: "CASE WHEN start_date IS NOT NULL AND start_time IS NOT NULL THEN start_date || ' ' || start_time ELSE NULL END",
      stored: true

    add_index :events, :start_date_time
  end

  def down
    remove_index :events, :start_date_time
    remove_column :events, :start_date_time
  end
end
