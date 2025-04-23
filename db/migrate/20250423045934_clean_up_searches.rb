class CleanUpSearches < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :searches, :users
    remove_index :searches, :user_id
    remove_column :searches, :user_id
    remove_column :searches, :query

    change_column_null :searches, :search_query_id, false
  end
end
