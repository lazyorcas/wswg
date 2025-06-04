class BookmarksController < ApplicationController
  before_action :require_user!
  before_action :require_city!

  def create
    build_bookmark
    return if @bookmark.persisted?

    begin
      @bookmark.save!
      flash.now[:success] = "Added \"#{@bookmark.event.title}\" to bookmarks"
    rescue => e
      Sentry.capture_exception(e)

      flash.now[:error] = "Failed to add \"#{@bookmark.event.title}\" to bookmarks"
      turbo_stream_flash(status: :unprocessable_entity)
    end
  end

  def update
    load_bookmark
    build_bookmark

    begin
      @bookmark.save!
      if @bookmark.removed?
        flash.now[:info] = "Removed \"#{@bookmark.event.title}\" from bookmarks"
      else
        flash.now[:success] = "Added \"#{@bookmark.event.title}\" to bookmarks"
      end
    rescue => e
      Sentry.capture_exception(e)

      flash.now[:error] = "Failed to update \"#{@bookmark.event.title}\" in bookmarks"
      turbo_stream_flash(status: :unprocessable_entity)
    end
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
    bookmark_params ? bookmark_params.permit(:removed, :event_id) : {}
  end
end
