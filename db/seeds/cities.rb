# Melbourne, Sydney, Seoul, Tokyo, Amsterdam, London, Lisbon, Madrid, Paris, Stockholm, Zurich, Boston, New York City, San Francisco, Toronto, Vancouver, Los Angeles, Chicago, Bangkok, Bali, Kuala Lumpur, Da Nang

CITIES = [
  {
    name: "Singapore",
    longitude: 103.849983,
    latitude: 1.289440,
    currency: "SGD",
    time_zone: "Asia/Singapore"
  },
  {
    name: "Barcelona",
    longitude: 2.170074,
    latitude: 41.386953,
    currency: "EUR",
    time_zone: "Europe/Berlin"
  },
  {
    name: "Munich",
    longitude: 11.575643,
    latitude: 48.137216,
    currency: "EUR",
    time_zone: "Europe/Berlin"
  },
  {
    name: "Berlin",
    longitude: 13.378091,
    latitude: 52.516486,
    currency: "EUR",
    time_zone: "Europe/Berlin"
  }
]

CITIES.each do |city_attributes|
  city = City.find_or_initialize_by(name: city_attributes[:name])
  if city.new_record?
    city.attributes = city_attributes.slice(*City.column_names)
    city.time_zone = TimeZone.find_by(name: city_attributes[:time_zone])
    city.save!
  end
end
