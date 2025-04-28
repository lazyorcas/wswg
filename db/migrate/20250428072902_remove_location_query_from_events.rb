class RemoveLocationQueryFromEvents < ActiveRecord::Migration[8.0]
  def change
    remove_column :events, :location_query
  end
end
