class Map::EventsController < ApplicationController
  include Temporal

  EVENT_LIMIT = 200

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
    load_bookmark if signed_in?
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
    return if Current.person.seen_events.include?(@event)

    Current.person.seen_events << @event
    Current.person.save!
  end

  def event_scope
    city = if params[:city_id].present?
      City.find(params[:city_id])
    else
      Current.person.city
    end

    Event
      .joins(:city_source)
      .where(city_source: { city: city })
  end
end
