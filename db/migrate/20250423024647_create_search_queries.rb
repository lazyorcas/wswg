class CreateSearchQueries < ActiveRecord::Migration[8.0]
  def change
    create_table :search_queries do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :query, null: false
      t.integer :status, null: false

      t.timestamps
    end

    add_reference :searches, :search_query, index: true
  end
end

# search_queries_attributes = Search.pluck(:user_id, :query, :status, :created_at, :updated_at).map do |user_id, query, status, created_at, updated_at|
#   {
#     user_id: user_id,
#     query: query,
#     status: status,
#     created_at: created_at,
#     updated_at: updated_at
#   }
# end
# SearchQuery.insert_all!(search_queries_attributes)
# search_query_mappings = SearchQuery.pluck(:created_at, :id).to_h
# Search.find_each do |search|
#   search.update_column(:search_query_id, search_query_mappings[search.created_at])
# end
