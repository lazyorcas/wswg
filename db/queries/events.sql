SELECT events.*
FROM events
INNER JOIN locations on locations.id = events.location_id
WHERE locations.full_address in (
  'Singapore, Singapore', 
  'Munich, Germany', 
  'Berlin, Germany', 
  'Barcelona, Spain'
)