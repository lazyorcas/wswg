class Map::EventsController < ApplicationController
  include BotProtection
  include CityDetection
  include CurrentPerson::Settings::PreferencesHelper

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

    ahoy.track "Viewed event", event_id: @event.id, source: "map"
    sort_by_converted
  end

  private

  def load_events
    @events = event_scope.where("CONCAT(start_date, 'T', start_time) >= ?", "#{@city.time_zone.current_date}T#{@city.time_zone.current_time}")
  end

  def order_events
    @events = if sort_by_time?
      @events.order(:start_date, :start_time)
    else
      @events
        .left_joins(:seen_users)
        .select("events.*, COUNT(DISTINCT users.id) as seen_count")
        .group("events.id, locations.id, sources.id, city.id")
        .order("seen_count DESC, events.start_date, events.start_time")
    end
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
      .joins(:city)
      .where(city: { id: @city.id })
  end
end
