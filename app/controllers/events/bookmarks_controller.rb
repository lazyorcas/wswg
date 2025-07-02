class Events::BookmarksController < ApplicationController
  include BotProtection

  protect_from_bots only: [ :show ]

  def show
    load_event
    build_bookmark
  end

  private

  def load_event
    @event = Event.find(params[:event_id])
  end

  def build_bookmark
    @bookmark ||= Bookmark.find_or_initialize_by(
      bookmarkable: Current.person,
      event: @event
    )
  end
end
