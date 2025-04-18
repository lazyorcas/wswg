class EventsController < ApplicationController
  RANDOM_EVENT_COUNT = 50

  before_action :require_user!
  after_action :add_event_to_seen_events, only: :show

  def index
    load_random_events
    filter_out_past_events
    @events = @events.includes(:source, :city, :location)
  end

  def show
    load_event
    load_bookmark
  end

  private

  def load_random_events
    @events = event_scope
      .order("RANDOM()")
      .limit(RANDOM_EVENT_COUNT)
  end

  def filter_out_past_events
    @events = @events.where(start_date: today..)
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
      .left_joins(:seen_users)
      .where(seens: { user_id: nil })
      .where(city: Current.user.city)
  end
end
