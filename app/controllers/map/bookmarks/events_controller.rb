class Map::Bookmarks::EventsController < ApplicationController
  include CityDetection

  before_action :require_user!

  def index
    load_events
    load_time_zone
    if @time_zone.nil?
      respond_to_city_not_found and return
    end
    filter_out_past_events
    order_events
    @events = @events.includes(:location, :source, :city)
  end

  private

  def load_events
    @events = event_scope
  end

  def load_time_zone
    @time_zone = begin
      city = get_city_from_visit || get_city_from_current_person
      city.time_zone
    end
  end

  def filter_out_past_events
    @events = @events.where(end_date: @time_zone.current_date..)
  end

  def order_events
    @events.order(:start_date, :start_time)
  end

  def event_scope
    Current.user.bookmarked_events.where(bookmarks: { removed: false })
  end
end
