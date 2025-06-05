class AddCityToSearchQueries < ActiveRecord::Migration[8.0]
  def change
    add_reference :search_queries, :city, foreign_key: true
  end
end

# SearchQuery.where(city: nil).find_each do |search_query|
#   next if search_query.searcher.city.nil?
#   search_query.update(city: search_query.searcher.city)
# end
