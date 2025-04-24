class AddSearchableModelTypeToSearches < ActiveRecord::Migration[8.0]
  def change
    add_column :searches, :searchable_model_type, :string
  end
end

# Search.update_all(searchable_model_type: "Searchable::English::Event")
