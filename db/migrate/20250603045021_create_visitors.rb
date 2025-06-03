class CreateVisitors < ActiveRecord::Migration[8.0]
  def change
    create_table :visitors do |t|
      t.belongs_to :city, null: false, foreign_key: true

      t.string :visitor_token, null: false, index: { unique: true }
      t.integer :credits, null: false, default: 0

      t.timestamps
    end
  end
end

# Ahoy::Visit.find_each do |visit|
#   Visitor.find_or_create_by(
#     city: City.find_by(name: visit.city),
#     visitor_token: visit.visitor_token
#   )
# end
