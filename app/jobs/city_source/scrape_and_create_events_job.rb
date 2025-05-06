class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  DEV_MAX_LIMIT = 10

  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3

  def perform(id, limit:)
    city_source = CitySource.find(id)

    events_attributes = city_source.source.scrape(city_source)
    create_event_jobs = build_create_event_jobs(
      events_attributes,
      city_source_id: id,
      limit: limit
    )

    if create_event_jobs.any?
      ActiveJob.perform_all_later(create_event_jobs)
    end
  end

  private

  def build_create_event_jobs(events_attributes, city_source_id:, limit:)
    event_urls = events_attributes.map { |event_attributes| event_attributes[:url] }.compact

    createable_urls = Event.extract_createable_urls_from_urls(event_urls).take(limit)

    createable_events_attributes = events_attributes.select do |event_attributes|
      createable_urls.include?(event_attributes[:url])
    end

    createable_events_attributes.map do |event_attributes|
      Event::CreateJob.new(city_source_id: city_source_id, **event_attributes)
    end
  end
end
