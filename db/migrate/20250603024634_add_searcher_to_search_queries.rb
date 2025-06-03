class AddSearcherToSearchQueries < ActiveRecord::Migration[8.0]
  def change
    add_reference :search_queries, :searcher, polymorphic: true
  end
end

# UPDATE search_queries SET searcher_type = 'User', searcher_id = user_id
