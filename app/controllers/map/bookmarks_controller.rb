class Map::BookmarksController < ApplicationController
  include CityDetection

  before_action :require_city!

  def index
    load_events
    filter_out_past_events
    order_events
    @events = @events.includes(:source, :location, :city)
  end

  private

  def load_events
    @events = event_scope
  end

  def filter_out_past_events
    @events = @events
      .joins(:city_source)
      .joins(:city)
      .where("start_date_time >= TO_CHAR(NOW() AT TIME ZONE cities.time_zone, 'YYYY-MM-DD HH24:MI:SS')")
  end

  def order_events
    @events.order(:start_date, :start_time)
  end

  def event_scope
    Current.person.bookmarked_events.where(bookmarks: { removed: false })
  end
end
