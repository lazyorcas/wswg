class AddNewEventCountToCitySources < ActiveRecord::Migration[8.0]
  def change
    add_column :city_sources, :new_event_count, :integer, default: 0
  end
end
