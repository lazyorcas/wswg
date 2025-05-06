SELECT 
  cities.name AS city_name, 
  sources.name AS source_name, 
  COUNT(events.id) AS event_count
FROM city_sources
INNER JOIN sources ON sources.id = city_sources.source_id
INNER JOIN cities ON cities.id = city_sources.city_id
INNER JOIN events ON events.city_source_id = city_sources.id
GROUP BY city.name, sources.name
ORDER BY city.name, sources.name
