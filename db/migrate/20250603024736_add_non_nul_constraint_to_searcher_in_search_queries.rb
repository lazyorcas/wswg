class AddNonNulConstraintToSearcherInSearchQueries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :search_queries, :searcher_id, false
    change_column_null :search_queries, :searcher_type, false
  end
end
