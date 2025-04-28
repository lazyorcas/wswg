class Event::LocateJob < ApplicationJob
  queue_with_priority 3

  def perform(id, location_query:)
    location_query = LocationQuery.find_or_create_by(query: location_query)
    return if location_query.persisted?

    event = Event.find(id)
    event.location_id = location_query.location_id
    event.save!
  end
end
