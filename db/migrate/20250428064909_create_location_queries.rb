class CreateLocationQueries < ActiveRecord::Migration[8.0]
  def change
    create_table :location_queries do |t|
      t.string :query, null: false, index: { unique: true }
      t.belongs_to :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end

# Event.located.find_each do |event|
#   location_query = LocationQuery.find_or_initialize_by(
#     query: event.location_query
#   )

#   if location_query.new_record?
#     location_query.location_id = event.location_id
#     location_query.save!
#   end
# end
