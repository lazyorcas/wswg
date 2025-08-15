class AddNonNullConstraintToBookmarkableTypeInBookmarks < ActiveRecord::Migration[8.0]
  def change
    change_column_null :bookmarks, :bookmarkable_type, false
  end
end
