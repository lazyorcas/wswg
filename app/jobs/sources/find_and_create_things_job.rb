class Sources::FindAndCreateThingsJob < ApplicationJob
  queue_with_priority 2

  def perform
    Source.find_each do |source|
      # proxy is expensive, so we only use it once a day
      next if source.proxy? && source.last_fetched_at.present? && source.last_fetched_at < 1.day.ago

      Source::FindAndCreateThingsJob.perform_later(source.id)
    end
  end
end
