class AddCityConstraintToSearchQueries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :search_queries, :city_id, false
  end
end
