WITH t AS (
  SELECT 
    id,
    plainto_tsquery(title) AS keywords_query
  FROM events
)
SELECT 
  interestable_id AS recommendable_id, 
  interestable_type AS recommendable_type, 
  t.id AS event_id, 
  ts_rank(interest_sets.keywords, t.keywords_query) as rank
FROM t
JOIN interest_sets ON interest_sets.keywords @@ t.keywords_query