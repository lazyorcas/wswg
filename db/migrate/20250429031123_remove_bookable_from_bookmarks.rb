class RemoveBookableFromBookmarks < ActiveRecord::Migration[8.0]
  def change
    remove_reference :bookmarks, :bookmarkable, null: true, polymorphic: true
  end
end
