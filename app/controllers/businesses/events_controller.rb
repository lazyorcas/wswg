class Businesses::EventsController < ApplicationController
  LIMIT = 1000

  layout "businesses"

  include BusinessesOnly

  def index
    load_events
    order_events
    limit_events
    eager_load_events_associations
  end

  private

  def load_events
    @events = event_scope
  end

  def order_events
    @events = @events.order(start_date: :desc)
  end

  def limit_events
    @events = @events.limit(1000)
  end

  def eager_load_events_associations
    @events = @events.includes(:source, :location, :city, :organizer)
  end

  def event_scope
    Event.joins(:city_source).where(city_sources: { city_id: Current.business.city_id })
  end
end
