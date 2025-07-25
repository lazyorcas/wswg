class FixUniqueIndexOnOrganizers < ActiveRecord::Migration[8.0]
  def change
    remove_index :organizers, [ :source_id, :url, :name ], unique: true
    add_index :organizers, [ :source_id, :url ], unique: true
  end
end
