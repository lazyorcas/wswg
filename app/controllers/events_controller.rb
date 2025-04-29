class EventsController < ApplicationController
  RANDOM_EVENT_COUNT = 50

  before_action :require_user!
  after_action :add_event_to_seen_events, only: :show

  helper_method :wday

  def index
    if wday == 6
      load_events_next_week
    else
      load_events_this_week
    end
    @events = @events.includes(:location, source: :city)
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

  def load_events_this_week
    @events = event_scope.where(end_date: today..today.end_of_week)
  end

  def load_events_next_week
    next_monday = today.end_of_week.next_occurring(:monday)
    next_sunday = today.end_of_week.next_occurring(:sunday)

    @events = event_scope.where(end_date: next_monday..next_sunday)
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
      .joins(:source)
      .left_joins(:seen_users)
      .where(seens: { user_id: nil })
      .where(source: { city: Current.user.city })
  end
end
