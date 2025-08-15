class Businesses::BookmarksController < ApplicationController
  layout "businesses"

  include BusinessesOnly

  def index
    load_bookmarks
    eager_load_bookmarks_associations
  end

  private

  def load_bookmarks
    @bookmarks = bookmark_scope
  end

  def eager_load_bookmarks_associations
    @bookmarks = @bookmarks.includes(bookmarkable: :source)
  end

  def bookmark_scope
    Bookmark.where(bookmarkable_type: "Organizer", bookmarker: Current.business)
  end
end
