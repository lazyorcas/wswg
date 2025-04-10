class BookmarksController < ApplicationController
  before_action :require_user!

  def index
    @events = Event.located.includes(:location)
    @center_location = @events.map(&:location).compact.first
  end
end
