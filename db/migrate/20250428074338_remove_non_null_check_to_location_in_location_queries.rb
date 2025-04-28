class RemoveNonNullCheckToLocationInLocationQueries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :location_queries, :location_id, true
  end
end
