class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  NO_EVENTS_FOUND_MAX_ATTEMPTS = 3

  queue_as :scraper
  limits_concurrency to: 2, key: ->(*) { self.class.name }

  retry_on Source::ScraperError, wait: 30.minutes, attempts: 3
  retry_on CitySource::NoEventsFoundError, wait: 5.minutes, attempts: NO_EVENTS_FOUND_MAX_ATTEMPTS

  def perform(id, limit:)
    city_source = CitySource.find(id)

    events_attributes = city_source.scrape
    if events_attributes.empty?
      raise CitySource::NoEventsFoundError(city_source)
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

  rescue CitySource::NoEventsFoundError => e
    attempts = exception_executions[e.class.to_s] || 0
    raise e if attempts + 1 < NO_EVENTS_FOUND_MAX_ATTEMPTS
  end
end
