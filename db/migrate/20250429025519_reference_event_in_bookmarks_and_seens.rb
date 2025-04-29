class ReferenceEventInBookmarksAndSeens < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookmarks, :event, null: true, foreign_key: true
    add_reference :seens, :event, null: true, foreign_key: true
  end
end

# Bookmark.update_all("event_id = bookmarkable_id")
# Seen.update_all("event_id = seenable_id")
