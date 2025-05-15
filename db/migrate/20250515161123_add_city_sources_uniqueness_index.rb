class AddCitySourcesUniquenessIndex < ActiveRecord::Migration[8.0]
  def change
    add_index :city_sources, [ :city_id, :source_id ], unique: true
  end
end
