class NoEventsFoundError < StandardError; end

class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  NO_EVENTS_FOUND_MAX_ATTEMPTS = 3

  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3
  retry_on NoEventsFoundError, wait: 5.minutes, attempts: NO_EVENTS_FOUND_MAX_ATTEMPTS

  rescue_from NoEventsFoundError do |exception|
    if (exception_executions[NoEventsFoundError.to_s] || 0) >= NO_EVENTS_FOUND_MAX_ATTEMPTS
      return
    end
    raise exception
  end

  def perform(id, limit:)
    city_source = CitySource.find(id)

    events_attributes = city_source.scrape
    raise NoEventsFoundError if events_attributes.empty?

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
