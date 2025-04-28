class RemoveCityFromLocations < ActiveRecord::Migration[8.0]
  def change
    remove_reference :locations, :city, index: true, foreign_key: true
  end
end
