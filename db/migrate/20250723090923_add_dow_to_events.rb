class AddDowToEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :events, :dow, :integer
    add_index :events, :dow
  end
end

# Event.update_all("dow = EXTRACT(ISODOW FROM start_date::date)")
