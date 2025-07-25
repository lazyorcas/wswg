class Businesses::EventsController < ApplicationController
  LIMIT = 1000
  PERMITTED_PARAMS = %i[keywords organizer_id dow tod location_id source_id]

  include BusinessesOnly

  layout "businesses"
  helper_method :event_query_params, *PERMITTED_PARAMS.map { |param| "filtering_by_#{param}?" }

  def index
    build_event_query
    query_events
    @events = Event.where(id: @event_ids).in_order_of(:id, @event_ids)
    limit_events
    eager_load_events_associations
  end

  private

  PERMITTED_PARAMS.each do |param|
    define_method "filtering_by_#{param}?" do
      event_query_params[param].present?
    end
  end

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
    params.permit(*PERMITTED_PARAMS)
  end
end
