class City::NotSupportedError < StandardError
  def initialize(city_name)
    @city_name = city_name
  end

  def message
    "This city is not supported yet. Only #{City.enabled.pluck(:name).to_sentence} are currently supported."
  end
end
