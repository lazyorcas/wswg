class RemoveModelTypeFromSearches < ActiveRecord::Migration[8.0]
  def change
    remove_column :searches, :model_type
  end
end
