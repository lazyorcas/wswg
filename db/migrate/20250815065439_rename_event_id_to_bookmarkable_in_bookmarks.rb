class RenameEventIdToBookmarkableInBookmarks < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookmarks, :event_id, :bookmarkable_id
    add_column :bookmarks, :bookmarkable_type, :string

    add_index :bookmarks, [ :bookmarker_type, :bookmarker_id, :bookmarkable_type, :bookmarkable_id ], unique: true
  end
end

# Bookmark.update_all(bookmarkable_type: "Event")
