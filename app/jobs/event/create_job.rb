class Event::CreateJob < ApplicationJob
  queue_as :default

  def perform(city_source_id:, uid:, url:)
    event = Event.find_or_initialize_by(
      city_source_id: city_source_id,
      uid: uid
    )

    if event.new_record?
      event.url = url
      event.fetch!
    end
  end
end
