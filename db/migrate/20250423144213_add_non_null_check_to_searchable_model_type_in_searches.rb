class AddNonNullCheckToSearchableModelTypeInSearches < ActiveRecord::Migration[8.0]
  def change
    change_column_null :searches, :searchable_model_type, false
  end
end
