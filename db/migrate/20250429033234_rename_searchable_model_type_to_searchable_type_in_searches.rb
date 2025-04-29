class RenameSearchableModelTypeToSearchableTypeInSearches < ActiveRecord::Migration[8.0]
  def change
    rename_column :searches, :searchable_model_type, :searchable_type
  end
end
