class RemoveRemoveFromBookmarks < ActiveRecord::Migration[8.0]
  def change
    remove_column :bookmarks, :removed_at
    remove_column :bookmarks, :removed
  end
end
