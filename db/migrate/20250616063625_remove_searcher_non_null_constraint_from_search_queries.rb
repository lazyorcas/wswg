class RemoveSearcherNonNullConstraintFromSearchQueries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :search_queries, :searcher_id, true
    change_column_null :search_queries, :searcher_type, true
  end
end
