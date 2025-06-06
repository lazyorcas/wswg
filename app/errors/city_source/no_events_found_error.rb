class CitySource::NoEventsFoundError < StandardError
  def initialize(city_source)
    @city_source = city_source
  end

  def message
    "No events found for #{@city_source.source.name} in #{@city_source.city.name}"
  end
end
