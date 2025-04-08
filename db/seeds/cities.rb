# https://en.wikipedia.org/wiki/List_of_largest_cities

CITIES = [
  { name: "Singapore", time_zone: "Singapore" },
  { name: "Barcelona", time_zone: "Madrid" },
  { name: "Munich", time_zone: "Berlin" },
  { name: "Berlin", time_zone: "Berlin" },
  { name: "Tokyo", time_zone: "Tokyo" }
]

CITIES.each do |city_attributes|
  city = City.find_or_initialize_by(name: city_attributes[:name])
  if city.new_record?
    city.assign_attributes(city_attributes)
    city.save!
  end
end
