class RemoveUniqueIndexOnUrlInOrganizers < ActiveRecord::Migration[8.0]
  def change
    remove_index :organizers, :url, unique: true
    add_index :organizers, :url
  end
end
