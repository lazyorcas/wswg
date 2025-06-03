class RemoveUserFromSearchQueries < ActiveRecord::Migration[8.0]
  def change
    remove_reference :search_queries, :user, foreign_key: true
  end
end
