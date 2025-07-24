class Businesses::EventsController < ApplicationController
  LIMIT = 1000

  layout "businesses"

  include BusinessesOnly

  def index
    build_event_query
    query_events
    @events = Event.where(id: @event_ids).in_order_of(:id, @event_ids)
    limit_events
    eager_load_events_associations
  end

  private

  def build_event_query
    @event_query = Business::EventQuery.new(
      city_id: Current.business.city_id,
      **event_query_params
    )
  end

  def query_events
    @event_ids = @event_query.query
  end

  def limit_events
    @events = @events.limit(LIMIT)
  end

  def eager_load_events_associations
    @events = @events.includes(:source, :location, :city, :organizer)
  end

  def event_query_params
    params.permit(:keywords, :organizer_id, :dow, :tod, :location_id, :source_id)
  end
end
