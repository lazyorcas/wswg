module Geospatial
  NOISE_RADIUS = 5
  EARTH_RADIUS = 6371

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
    d = EARTH_RADIUS * c

    d
  end

  # Adds random noise to coordinates within a 5km radius
  # @param coords [Hash] The original coordinates with :lat and :lon keys
  # @return [Hash] New coordinates with random noise applied
  def self.add_noise_to_coords(coords)
    # Convert to radians for calculations
    lat_rad = coords[:lat] * Math::PI / 180
    lon_rad = coords[:lon] * Math::PI / 180

    # Generate random distance (0 to 5km) and bearing (0 to 360 degrees)
    distance = rand * NOISE_RADIUS  # Random distance between 0 and 5 km
    bearing = rand * 2 * Math::PI  # Random bearing in radians

    # Calculate new coordinates
    angular_distance = 1.0 * distance / EARTH_RADIUS

    new_lat_rad = Math.asin(
      Math.sin(lat_rad) * Math.cos(angular_distance) +
      Math.cos(lat_rad) * Math.sin(angular_distance) * Math.cos(bearing)
    )

    new_lon_rad = lon_rad + Math.atan2(
      Math.sin(bearing) * Math.sin(angular_distance) * Math.cos(lat_rad),
      Math.cos(angular_distance) - Math.sin(lat_rad) * Math.sin(new_lat_rad)
    )

    # Convert back to degrees
    {
      lat: new_lat_rad * 180 / Math::PI,
      lon: new_lon_rad * 180 / Math::PI
    }
  end
end
