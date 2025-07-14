class AddEventsFinalizableToSources < ActiveRecord::Migration[8.0]
  def change
    add_column :sources, :events_finalizable, :boolean
  end
end

# Source.where(name: ["Luma"]).update_all(events_finalizable: true)
