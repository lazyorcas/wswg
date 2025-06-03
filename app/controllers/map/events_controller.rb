class Map::EventsController < ApplicationController
  include Temporal

  EVENT_LIMIT = 200

  before_action :require_user!
  before_action :require_city!

  after_action :add_event_to_seen_events, only: :show

  def index
    load_events
    order_events
    limit_events
    @events = @events.includes(:location, :source, :city)
  end

  def show
    load_event
    load_bookmark
  end

  private

  def load_events
    @events = event_scope.where(end_date: current_date..)
  end

  def order_events
    @events = @events.order(:start_date, :start_time)
  end

  def limit_events
    @events = @events.limit(EVENT_LIMIT)
  end

  def load_event
    @event = Event.find(params[:id])
  end

  def load_bookmark
    @bookmark = @event.bookmarks.find_or_initialize_by(user: Current.user)
  end

  def add_event_to_seen_events
    return if Current.user.seen_events.include?(@event)

    Current.user.seen_events << @event
    Current.user.save!
  end

  def event_scope
    Event
      .joins(:city_source)
      .left_joins(:seen_users)
      .where(seens: { user_id: nil })
      .where(city_source: { city: Current.user.city })
  end
end
