CITIES_ATTRIBUTES = [
  # North America
  [ "Boston",         42.360082, -71.058880, "USD", "America/New_York", "US" ],
  [ "Chicago",        41.878113, -87.629798, "USD", "America/Chicago", "US" ],
  [ "Los Angeles",    34.052235, -118.243683, "USD", "America/Los_Angeles", "US" ],
  [ "Montreal",       45.501689, -73.567256, "CAD", "America/New_York", "CA" ],
  [ "New York City",  40.712776, -74.005974, "USD", "America/New_York", "US" ],
  [ "San Francisco",  37.787281, -122.407132, "USD", "America/Los_Angeles", "US" ],
  [ "Toronto",        43.653225, -79.383186, "CAD", "America/New_York", "CA" ],
  [ "Vancouver",      49.282729, -123.120735, "CAD", "America/Los_Angeles", "CA" ],

  # Europe
  [ "Amsterdam",      52.373290, 4.892531, "EUR", "Europe/Amsterdam", "NL" ],
  [ "Barcelona",      41.386953, 2.170074, "EUR", "Europe/Madrid", "ES" ],
  [ "Berlin",         52.516486, 13.378091, "EUR", "Europe/Berlin", "DE" ],
  [ "Lisbon",         38.710611, -9.137630, "EUR", "Europe/Lisbon", "PT" ],
  [ "London",         51.513406, -0.136436, "GBP", "Europe/London", "GB" ],
  [ "Madrid",         40.416775, -3.703790, "EUR", "Europe/Madrid", "ES" ],
  [ "Munich",         48.137356, 11.574874, "EUR", "Europe/Berlin", "DE" ],
  [ "Paris",          48.863440, 2.336941, "EUR", "Europe/Paris", "FR" ],

  # Asia
  [ "Bali",           -8.409518, 115.188919, "IDR", "Asia/Singapore", "ID" ],
  [ "Bangkok",        13.739514, 100.512083, "THB", "Asia/Bangkok", "TH" ],
  [ "Da Nang",        16.055234, 108.244696, "VND", "Asia/Bangkok", "VN" ],
  [ "Kuala Lumpur",   3.152451, 101.704001, "MYR", "Asia/Kuala_Lumpur", "MY" ],
  [ "Seoul",          37.566535, 126.977969, "KRW", "Asia/Seoul", "KR" ],
  [ "Singapore",      1.283649, 103.858892, "SGD", "Asia/Singapore", "SG" ],
  [ "Tokyo",          35.689487, 139.691711, "JPY", "Asia/Tokyo", "JP" ],

  # Australia
  [ "Melbourne",      -37.813773, 144.963061, "AUD", "Australia/Melbourne", "AU" ],
  [ "Sydney",         -33.871055, 151.211526, "AUD", "Australia/Sydney", "AU" ]
]

CITIES_ATTRIBUTES.each do |attrs_array|
  name = attrs_array[0]
  city = City.find_or_initialize_by(name: name)

  if city.new_record?
    city.attributes = {
      name: name,
      lat: attrs_array[1],
      lon: attrs_array[2],
      currency: attrs_array[3],
      time_zone: attrs_array[4],
      country_code: attrs_array[5]
    }
    city.save!
  end
end
