class CitySchema < RubyLLM::Schema
  any_of :city, description: "City name. Use null if unknown. If the city isn't in the list of supported cities, return \"NOT_SUPPORTED\"." do
    string enum: [ *City.enabled.pluck(:name), "NOT_SUPPORTED", "" ]
    null
  end
end
