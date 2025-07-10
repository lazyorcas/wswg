module Marketing::Events::NearbyFilter
  def filter_events_by_nearby
    @events = @events.joins(:location).within(max_distance_to_city, origin: origin)
  end

  private

  def max_distance_to_city
    Event::Locatable::MAX_DISTANCE_TO_CITY
  end

  def origin
    city.coordinates_arr
  end
end
