class NoEventsFoundError < StandardError; end

class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3
  retry_on NoEventsFoundError, wait: 1.minute, attempts: 5

  def perform(id, limit:)
    city_source = CitySource.find(id)

    events_attributes = city_source.scrape
    if events_attributes.empty?
      raise NoEventsFoundError
    end

    events_attributes = events_attributes.take(limit)

    create_event_jobs = Event.build_create_event_jobs(
      events_attributes,
      city_source_id: id
    )

    if create_event_jobs.any?
      ActiveJob.perform_all_later(create_event_jobs)
    end
  end
end
