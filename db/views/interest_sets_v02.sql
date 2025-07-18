WITH persons AS (
  SELECT users.id, 'User' AS person_type 
  FROM users
  JOIN ahoy_visits ON ahoy_visits.user_id = users.id
  WHERE ahoy_visits.started_at > NOW() - INTERVAL '1 day'

  UNION ALL

  SELECT visitors.id, 'Visitor' AS person_type 
  FROM visitors
  JOIN ahoy_visits ON ahoy_visits.visitor_token = visitors.visitor_token
  WHERE ahoy_visits.started_at > NOW() - INTERVAL '1 day'
)
SELECT 
  persons.id AS interestable_id,
  persons.person_type AS interestable_type,
  tsvector_agg(events.keywords) AS keywords
FROM persons
JOIN seens ON seenable_id = persons.id AND seenable_type = person_type
JOIN events ON events.id = seens.event_id
GROUP BY 1, 2