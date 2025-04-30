class AddEnabledToCitiesAndSources < ActiveRecord::Migration[8.0]
  def change
    add_column :cities, :enabled, :boolean, default: false
    add_column :sources, :enabled, :boolean, default: false
  end
end
