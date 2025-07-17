class MaterializedRecommendation < ApplicationRecord
  belongs_to :recommendable, polymorphic: true
  belongs_to :event, class_name: "::Event"

  def readonly?
    true
  end

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name, concurrently: true)
  end
end
