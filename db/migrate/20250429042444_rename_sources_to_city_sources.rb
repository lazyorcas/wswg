class RenameSourcesToCitySources < ActiveRecord::Migration[8.0]
  def change
    rename_column :events, :source_id, :city_source_id
    rename_table :sources, :city_sources
  end
end
