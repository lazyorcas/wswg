class RemoveThingTypeFromSources < ActiveRecord::Migration[8.0]
  def change
    remove_column :sources, :thing_type
  end
end
