class Business::Organizer::BookmarkTableComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(bookmark)
    @bookmark = bookmark
  end

  def organizer
    if @bookmark.bookmarkable.present?
      @bookmark.bookmarkable.name || @bookmark.bookmarkable.url
    else
      nil
    end
  end

  def organizer_url
    if @bookmark.bookmarkable.present?
      @bookmark.bookmarkable.url || build_google_query_url_for_organizer
    else
      nil
    end
  end

  private

  def build_google_query_url_for_organizer
    intitle = @bookmark.bookmarkable.name
    inurl = @bookmark.bookmarkable.source.name.downcase
    query = "intitle:\"#{intitle}\" inurl:\"#{inurl}\""
    "https://www.google.com/search?q=#{CGI.escape(query)}"
  end
end
