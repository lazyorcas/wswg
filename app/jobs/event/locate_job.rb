class Event::LocateJob < ApplicationJob
  MAX_DISTANCE_IN_KM = 50

  queue_with_priority 3

  def perform(id, location_query:)
    location_query = LocationQuery.find_or_create_by(query: location_query)
    return if location_query.location_id.blank?

    event = Event.find(id)

    coordinates = location_query.location.coordinates
    city_coordinates = event.city_source.city.coordinates

    distance_from_city_center = Geospatial.distance_in_km_between(coordinates, city_coordinates)

    if distance_from_city_center > MAX_DISTANCE_IN_KM
      raise StandardError.new("Event is too far away")
    end

    event.location_id = location_query.location_id
    event.save!
  end
end
