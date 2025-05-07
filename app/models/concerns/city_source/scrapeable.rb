module CitySource::Scrapeable
  extend ActiveSupport::Concern

  def queue_scrape(limit)
    ScrapeAndCreateEventsJob.perform_later(id, limit: limit)
  end

  def scrape(limit)
    events_attributes = source.scrape(self)

    create_event_jobs = Event.build_create_event_jobs(
      events_attributes,
      city_source_id: id,
      limit: limit
    )

    if create_event_jobs.any?
      ActiveJob.perform_all_later(create_event_jobs)
    end
  end
end
