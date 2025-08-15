class RenameBookmarkableToBookmarkerInBookmarks < ActiveRecord::Migration[8.0]
  def change
    rename_column :bookmarks, :bookmarkable_type, :bookmarker_type
    rename_column :bookmarks, :bookmarkable_id, :bookmarker_id
  end
end
