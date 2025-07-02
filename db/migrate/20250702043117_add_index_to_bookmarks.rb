class AddIndexToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_index :bookmarks, [ :bookmarkable_type, :bookmarkable_id, :event_id ], unique: true
  end
end
