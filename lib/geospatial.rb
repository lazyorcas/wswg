module Geospatial
  # Haversine formula
  # a = sin²(Δφ/2) + cos(φ1) * cos(φ2) * sin²(Δλ/2)
  # c = 2 * atan2(√a, √(1-a))
  # d = R * c
  # where φ is latitude, λ is longitude, R is the radius of the earth (mean radius = 6,371km)
  def self.distance_in_km_between(coords1, coords2)
    lat1 = coords1[:lat] * Math::PI / 180
    lon1 = coords1[:lon] * Math::PI / 180
    lat2 = coords2[:lat] * Math::PI / 180
    lon2 = coords2[:lon] * Math::PI / 180

    dlat = lat2 - lat1
    dlon = lon2 - lon1

    a = Math.sin(dlat / 2) ** 2 + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dlon / 2) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    d = 6371 * c

    d
  end
end
