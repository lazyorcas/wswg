class CitySource::FindAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3

  def perform(id, page_count_modifier: 1)
    return if page_count_modifier.zero?

    city_source = CitySource.find(id)

    event_urls = scrape_events(city_source)
    create_event_jobs = build_create_event_jobs(event_urls, city_source_id: id)

    if create_event_jobs.any?
      ActiveJob.perform_all_later(create_event_jobs)
    end

    city_source.update(last_fetched_at: Time.current)
  end

  private

  def scrape_events(city_source)
    source = city_source.source
    strategy = source.strategy_class.new(page_count_modifier: page_count_modifier)
    scraper = source.scraper_class.new(source, strategy: strategy)

    scraper.find_events_from_city_source(city_source)
  end

  def build_create_event_jobs(event_urls, city_source_id:)
    createable_event_urls = Event.get_createable_urls(event_urls)
    createable_event_urls.map do |event_url|
      Event::CreateJob.new(city_source_id: city_source_id, url: event_url)
    end
  end
end
