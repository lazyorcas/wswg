class Businesses::Organizers::BookmarksController < ApplicationController
  layout "businesses"

  include BusinessesOnly

  before_action :load_organizer

  def create
    build_bookmark
    @bookmark.save!

    flash.now[:success] = "Organizer bookmarked"
  end

  def show
    load_bookmark
    build_bookmark if @bookmark.nil?
  end

  def destroy
    load_bookmark
    @bookmark.destroy!

    flash.now[:info] = "Organizer unbookmarked"
  end

  private

  def load_organizer
    @organizer = Organizer.find(params[:organizer_id])
  end

  def build_bookmark
    @bookmark ||= bookmark_scope.build
    @bookmark.bookmarkable = @organizer
  end

  def load_bookmark
    @bookmark = bookmark_scope.find_by(bookmarkable_id: @organizer.id)
  end

  def bookmark_scope
    Bookmark.where(bookmarkable_type: "Organizer", bookmarker: Current.business)
  end
end
