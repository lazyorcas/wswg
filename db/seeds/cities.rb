# https://en.wikipedia.org/wiki/List_of_largest_cities

CITIES = [
  {
    name: "Singapore",
    longitude: 103.849983,
    latitude: 1.289440,
    currency: "SGD"
  },
  {
    name: "Barcelona",
    longitude: 2.170074,
    latitude: 41.386953,
    currency: "EUR"
  },
  {
    name: "Munich",
    longitude: 11.575643,
    latitude: 48.137216,
    currency: "EUR"
  },
  {
    name: "Berlin",
    longitude: 13.378091,
    latitude: 52.516486,
    currency: "EUR"
  },
  {
    name: "Paderborn",
    longitude: 8.753953,
    latitude: 51.717229,
    currency: "EUR"
  }
  # { name: "Tokyo" }
]

CITIES.each do |city_attributes|
  city = City.find_or_initialize_by(name: city_attributes[:name])
  if city.new_record?
    city.assign_attributes(city_attributes)
    city.save!
  end
end
