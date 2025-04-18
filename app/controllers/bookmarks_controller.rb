class BookmarksController < ApplicationController
  before_action :require_user!

  def create
    build_bookmark
    @bookmark.save!

    flash.now[:success] = "Added <b>\"#{@bookmark.bookmarkable.title}\"</b> to bookmarks".html_safe
  rescue => e
    flash.now[:error] = e.message
    turbo_stream_flash
  end

  def update
    load_bookmark
    build_bookmark
    @bookmark.save!

    if @bookmark.removed?
      flash.now[:info] = "Removed <b>\"#{@bookmark.bookmarkable.title}\"</b> from bookmarks".html_safe
    else
      flash.now[:success] = "Added <b>\"#{@bookmark.bookmarkable.title}\"</b> to bookmarks".html_safe
    end
  rescue => e
    flash.now[:error] = e.message
    turbo_stream_flash
  end

  private

  def load_bookmark
    @bookmark = bookmark_scope.find(params[:id])
  end

  def build_bookmark
    @bookmark ||= bookmark_scope.build
    @bookmark.attributes = bookmark_params
  end

  def bookmark_scope
    Current.user.bookmarks
  end

  def bookmark_params
    bookmark_params = params[:bookmark]
    bookmark_params ? bookmark_params.permit(:removed, :bookmarkable_id, :bookmarkable_type) : {}
  end
end
