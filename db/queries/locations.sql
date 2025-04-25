SELECT locations.id, locations.full_address, cities.name as city_name,
  (
    6371 * acos(
    cos(radians(cities.latitude)) *
    cos(radians(locations.latitude)) *
    cos(radians(locations.longitude) - radians(cities.longitude)) +
    sin(radians(cities.latitude)) *
  sin(radians(locations.latitude))
  )
) as distance_in_km
FROM locations
JOIN cities ON locations.city_id = cities.id
ORDER BY distance_in_km desc;