class AddEventIdIndexToMaterializedRecommendations < ActiveRecord::Migration[8.0]
  def change
    add_index :materialized_recommendations, :event_id
  end
end
