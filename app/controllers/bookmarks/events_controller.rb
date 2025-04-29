class Bookmarks::EventsController < ApplicationController
  before_action :require_user!

  def index
    load_events
    filter_out_past_events
    order_events
    @events = @events.includes(:location, city_source: [ :source, :city ])
  end

  private

  def load_events
    @events = event_scope
  end

  def filter_out_past_events
    @events = @events.where(end_date: today..)
  end

  def order_events
    @events.order(:start_date, :start_time)
  end

  def event_scope
    Current.user.bookmarked_events
  end
end
