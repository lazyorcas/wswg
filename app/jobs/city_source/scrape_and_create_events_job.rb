class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  NO_EVENTS_FOUND_MAX_ATTEMPTS = 3

  queue_as :scraper
  limits_concurrency to: 1, key: ->(id, limit:) { id }, on_conflict: :discard

  retry_on Source::ScraperError, wait: 10.minutes, attempts: 3
  retry_on CitySource::NoEventsFoundError, wait: 10.minutes, attempts: NO_EVENTS_FOUND_MAX_ATTEMPTS

  def perform(id, limit:)
    city_source = CitySource.find(id)

    events_attributes = city_source.scrape
    if events_attributes.empty?
      raise CitySource::NoEventsFoundError.new(
        source_name: city_source.source.name,
        city_name: city_source.city.name
      )
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
    raise e if executions_for(e) < NO_EVENTS_FOUND_MAX_ATTEMPTS
  end
end
