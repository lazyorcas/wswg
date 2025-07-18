class DropViews < ActiveRecord::Migration[8.0]
  def change
    drop_view :materialized_recommendations, revert_to_version: 1, materialized: true
    drop_view :recommendations, revert_to_version: 1
    drop_view :interest_sets, revert_to_version: 1
  end
end
