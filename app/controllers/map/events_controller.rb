class Map::EventsController < ApplicationController
  include BotProtection
  include CityDetection

  EVENT_LIMIT = 200

  protect_from_bots only: [ :index, :show ]
  before_action :require_city!, only: [ :index ]
  after_action :add_event_to_seen_events, only: [ :show ]

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
    @events = event_scope.where(start_date: @city.time_zone.current_date..)
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
    Person::AddEventToSeenEventsJob.perform_later(
      person_type: Current.person.class.name,
      person_id: Current.person.id,
      event_id: @event.id
    )
  end

  def event_scope
    Event
      .joins(:city_source)
      .where(city_source: { city: @city })
  end
end
