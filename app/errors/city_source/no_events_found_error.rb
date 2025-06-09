class CitySource::NoEventsFoundError < StandardError
  def initialize(source_name:, city_name:)
    @source_name = source_name
    @city_name = city_name
  end

  def message
    "No events found for #{@source_name} in #{@city_name}"
  end
end
