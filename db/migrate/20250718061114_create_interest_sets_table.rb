class CreateInterestSetsTable < ActiveRecord::Migration[8.0]
  def change
    create_table :interest_sets do |t|
      t.belongs_to :interestable, polymorphic: true, null: false
      t.tsvector :keywords, null: false

      t.timestamps
    end

    add_index :interest_sets, [ :interestable_type, :interestable_id ], unique: true
    add_index :interest_sets, :keywords, using: "gin"
  end
end

# WITH persons AS (
#   SELECT id, 'User' AS person_type FROM users
#   UNION ALL
#   SELECT id, 'Visitor' AS person_type FROM visitors
# ),
# t AS (
#   SELECT
#     persons.id AS interestable_id,
#     persons.person_type AS interestable_type,
#     tsvector_agg(keywords) AS keywords,
#     MIN(seens.created_at) AS created_at,
#     MAX(seens.created_at) AS updated_at
#   FROM persons
#   JOIN seens ON seenable_id = persons.id AND seenable_type = person_type
#   JOIN events ON events.id = seens.event_id
#   GROUP BY 1, 2
# )
# INSERT INTO interest_sets (interestable_id, interestable_type, keywords, created_at, updated_at)
# SELECT interestable_id, interestable_type, keywords, created_at, updated_at
# FROM t;
