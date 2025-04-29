class Sources::FindAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  def perform
    CitySource.includes(:source).find_each do |city_source|
      # proxy is expensive, so we only use it once a day
      next if city_source.source.proxy? && city_source.last_fetched_at.present? && city_source.last_fetched_at > 1.day.ago

      Source::FindAndCreateEventsJob.perform_later(city_source.id)
    end
  end
end
