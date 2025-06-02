class NoEventsFoundError < StandardError; end

class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  NO_EVENTS_FOUND_MAX_ATTEMPTS = 3

  queue_with_priority 2
  limits_concurrency limit: 2, key: -> { self.class.name }

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3
  retry_on Ferrum::JavaScriptError, wait: 15.minutes, attempts: 3
  retry_on NoEventsFoundError, wait: 5.minutes, attempts: NO_EVENTS_FOUND_MAX_ATTEMPTS

  def perform(id, limit:)
    city_source = CitySource.find(id)

    events_attributes = city_source.scrape
    if events_attributes.empty?
      if (exception_executions[NoEventsFoundError.to_s] || 0) >= NO_EVENTS_FOUND_MAX_ATTEMPTS
        return
      end
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

    city_source.update(last_fetched_at: Time.current)
  end
end
