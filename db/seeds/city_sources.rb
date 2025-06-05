CITY_SOURCES_ATTRIBUTES = [
  # Barcelona
  [ "Barcelona", "Eventbrite", { city_slug: "spain--barcelona" } ],
  [ "Barcelona", "Luma", { city_slug: "barcelona" } ],
  [ "Barcelona", "Meetup", { city_slug: "es--barcelona" } ],
  [ "Barcelona", "Ticketmaster", {} ],

  # Berlin
  [ "Berlin", "Eventbrite", { city_slug: "germany--berlin" } ],
  [ "Berlin", "Luma", { city_slug: "berlin" } ],
  [ "Berlin", "Meetup", { city_slug: "de--Berlin" } ],
  [ "Berlin", "Ticketmaster", {} ],

  # London
  [ "London", "Eventbrite", { city_slug: "united-kingdom--london" } ],
  [ "London", "Luma", { city_slug: "london" } ],
  [ "London", "Meetup", { city_slug: "gb--London" } ],
  [ "London", "Ticketmaster", {} ],

  # Munich
  [ "Munich", "Eventbrite", { city_slug: "germany--münchen" } ],
  [ "Munich", "Luma", { city_slug: "munich" } ],
  [ "Munich", "Meetup", { city_slug: "de--München" } ],
  [ "Munich", "Ticketmaster", {} ],

  # New York City
  [ "New York City", "Eventbrite", { city_slug: "ny--new-york" } ],
  [ "New York City", "Luma", { city_slug: "nyc" } ],
  [ "New York City", "Meetup", { city_slug: "us--ny--New York" } ],
  [ "New York City", "Ticketmaster", {} ],

  # Paris
  [ "Paris", "Eventbrite", { city_slug: "france--paris" } ],
  [ "Paris", "Luma", { city_slug: "paris" } ],
  [ "Paris", "Meetup", { city_slug: "fr--Paris" } ],
  [ "Paris", "Ticketmaster", {} ],

  # San Francisco
  [ "San Francisco", "Eventbrite", { city_slug: "ca--san-francisco" } ],
  [ "San Francisco", "Luma", { city_slug: "sf" } ],
  [ "San Francisco", "Meetup", { city_slug: "us--ca--San Francisco" } ],
  [ "San Francisco", "Ticketmaster", {} ],

  # Singapore
  [ "Singapore", "Eventbrite", { city_slug: "singapore" } ],
  [ "Singapore", "Luma", { city_slug: "singapore" } ],
  [ "Singapore", "Meetup", { city_slug: "sg--singapore" } ],
  [ "Singapore", "Ticketmaster", {} ],

  # Toronto
  [ "Toronto", "Eventbrite", { city_slug: "canada--toronto" } ],
  [ "Toronto", "Luma", { city_slug: "toronto" } ],
  [ "Toronto", "Meetup", { city_slug: "ca--on--Toronto" } ],
  [ "Toronto", "Ticketmaster", {} ],

  # Tokyo
  [ "Tokyo", "Eventbrite", { city_slug: "japan--tokyo" } ],
  [ "Tokyo", "Luma", { city_slug: "tokyo" } ],
  [ "Tokyo", "Meetup", { city_slug: "jp--Tokyo" } ],
  [ "Tokyo", "Ticketmaster", {} ]
]

CITY_SOURCES_ATTRIBUTES.each do |attrs_array|
  city_id = City.find_by(name: attrs_array[0]).id
  source_id = Source.find_by(name: attrs_array[1]).id

  city_source = CitySource.find_or_initialize_by(
    city_id: city_id,
    source_id: source_id
  )

  if city_source.new_record?
    city_source.attributes = {
      url_params: attrs_array[2]
    }
    city_source.save!
  end
end

# city = City.create(name: "", country_code: "", currency: "", lat: 0, lon: 0, time_zone: "")
# [
#   [ "Eventbrite", { city_slug: "" } ],
#   [ "Luma", { city_slug: "" } ],
#   [ "Meetup", { city_slug: "" } ],
#   [ "Ticketmaster", {} ]
# ].each do |attrs_array|
#   source_id = Source.find_by(name: attrs_array[0]).id
#   CitySource.create(
#     city_id: city.id,
#     source_id: source_id,
#     url_params: attrs_array[1],
#     enabled: true
#   )
# end
