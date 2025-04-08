class Event::CreateJob < ApplicationJob
  queue_as :default

  retry_on Net::ReadTimeout, wait: 10.seconds, attempts: 3

  def perform(city_id:, city_source_id:, uid:, url:)
    event = Event.find_or_initialize_by(
      city_source_id: city_source_id,
      uid: uid
    )

    if event.new_record?
      event.city_id = city_id
      event.url = url
      event.fetch!
    end
  end
end
