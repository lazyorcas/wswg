class RefreshMaterializedRecommendationsJob < ApplicationJob
  queue_as :user
  queue_with_priority 0

  def perform
    MaterializedRecommendation.refresh
  end
end
