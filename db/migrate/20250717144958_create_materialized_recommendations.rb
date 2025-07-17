class CreateMaterializedRecommendations < ActiveRecord::Migration[8.0]
  def up
    create_view :materialized_recommendations, materialized: true

    add_index :materialized_recommendations, [ :recommendable_id, :recommendable_type ], name: "idx_materialized_recommendations_on_recommendable_id_and_type"
    add_index :materialized_recommendations, [ :recommendable_id, :recommendable_type, :event_id ], unique: true, name: "uniq_idx_materialized_recommendations"
  end

  def down
    remove_index :materialized_recommendations, name: "uniq_idx_materialized_recommendations"
    remove_index :materialized_recommendations, name: "idx_materialized_recommendations_on_recommendable_id_and_type"

    drop_view :materialized_recommendations, materialized: true
  end
end
