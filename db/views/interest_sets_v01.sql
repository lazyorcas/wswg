WITH persons AS (
  SELECT id, 'User' AS person_type FROM users
  UNION ALL
  SELECT id, 'Visitor' AS person_type FROM visitors
)
SELECT 
  persons.id AS interestable_id,
  persons.person_type AS interestable_type,
  tsvector_agg(keywords) AS keywords
FROM persons
JOIN seens ON seenable_id = persons.id AND seenable_type = person_type
JOIN events ON events.id = seens.event_id
-- WHERE seens.created_at > NOW() - INTERVAL '30 days'
GROUP BY 1, 2