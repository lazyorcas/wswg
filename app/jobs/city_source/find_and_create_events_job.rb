class CitySource::FindAndCreateEventsJob < ApplicationJob
  queue_with_priority 2

  retry_on Ferrum::TimeoutError, wait: 30.minutes, attempts: 3
  retry_on Ferrum::NodeNotFoundError, wait: 1.minute, attempts: 3

  def perform(id)
    city_source = CitySource.find(id)

    source = city_source.source
    source.extend("Source::#{source.name}".constantize)

    source.find_and_create_events!(city_source)

    city_source.update(last_fetched_at: Time.current)
  end
end
