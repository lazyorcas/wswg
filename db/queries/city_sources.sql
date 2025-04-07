-- Get all city and source pairs that don't exist in the database
SELECT cities.name AS city, sources.homepage_url AS source_url
FROM cities
CROSS JOIN sources
LEFT JOIN city_sources ON
    city_sources.city_id = cities.id AND
    city_sources.source_id = sources.id
WHERE city_sources.id IS NULL

-- Get city source URLs by city
SELECT cities.name AS city, city_sources.url AS url
FROM cities
INNER JOIN city_sources ON
    city_sources.city_id = cities.id