class RemoveTypeFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :type
  end
end
