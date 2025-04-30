class CitySource::ScrapeAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3

  def perform(id, limit:)
    city_source = CitySource.find(id)

    event_urls = city_source.source.scrape(city_source)
    create_event_jobs = build_create_event_jobs(
      event_urls,
      city_source_id: id,
      limit: limit
    )

    if create_event_jobs.any?
      ActiveJob.perform_all_later(create_event_jobs)
    end

    city_source.update(last_fetched_at: Time.current)
  end

  private

  def build_create_event_jobs(event_urls, city_source_id:, limit:)
    urls = Event.get_createable_urls(event_urls).take(limit)
    urls.map do |url|
      Event::CreateJob.new(city_source_id: city_source_id, url: url)
    end
  end
end
