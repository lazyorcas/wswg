# https://en.wikipedia.org/wiki/List_of_largest_cities

CITY_NAMES = [
  # # Asia & Pacific
  # "Bangkok",
  # "Bengaluru",
  # "Dubai",
  # "Ho Chi Minh City",
  # "Hong Kong",
  # "Jakarta",
  # "Kuala Lumpur",
  # "Manila",
  # "Melbourne",
  # "Mumbai",
  # "New Delhi",
  # "Seoul",
  "Singapore"
  # "Sydney",
  # "Taipei",
  # "Tokyo",
  # # Africa
  # "Lagos",
  # "Nairobi",
  # # Europe
  # "Amsterdam",
  # "Barcelona",
  # "Berlin",
  # "Brussels",
  # "Copenhagen",
  # "Geneva",
  # "Helsinki",
  # "Istanbul",
  # "Lausanne",
  # "Lisbon",
  # "London",
  # "Madrid",
  # "Milan",
  # "Munich",
  # "Paris",
  # "Stockholm",
  # "Zurich",
  # # North America
  # "Atlanta",
  # "Austin",
  # "Boston",
  # "Calgary",
  # "Chicago",
  # "Dallas",
  # "Denver",
  # "Houston",
  # "Las Vegas",
  # "Los Angeles",
  # "Mexico City",
  # "Miami",
  # "Montréal",
  # "New York",
  # "Philadelphia",
  # "Phoenix",
  # "Portland",
  # "Salt Lake City",
  # "San Diego",
  # "San Francisco",
  # "Seattle",
  # "Toronto",
  # "Vancouver",
  # "Washington DC",
  # "Waterloo",
  # # South America
  # "Bogotá",
  # "Buenos Aires",
  # "Medellín",
  # "São Paulo"
]

CITY_NAMES.each do |city_name|
  City.find_or_create_by!(name: city_name)
end
