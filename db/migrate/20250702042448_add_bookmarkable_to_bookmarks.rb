class AddBookmarkableToBookmarks < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookmarks, :bookmarkable, polymorphic: true
  end
end

# UPDATE bookmarks
# SET bookmarkable_type = 'User', bookmarkable_id = user_id
# WHERE user_id IS NOT NULL
