class BookmarksController < ApplicationController
  before_action :require_user!

  def index
    @events = Event.order("RANDOM()").limit(10).includes(:location)
    @center_location = @events.map(&:location).compact.first
  end
end
