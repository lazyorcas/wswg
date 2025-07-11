module Marketing::Events::CityFilter
  def filter_events_by_city
    @events = @events.joins(:city_source).where(city_sources: { city_id: @city.id })
  end
end
