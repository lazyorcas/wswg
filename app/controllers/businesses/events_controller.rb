class Businesses::EventsController < ApplicationController
  LIMIT = 1000
  PERMITTED_PARAMS = %i[keywords event_id organizer_id location_id source_id dow tod]

  include BusinessesOnly

  layout "businesses"
  helper_method :event_query_params, *PERMITTED_PARAMS.map { |param| "filtering_by_#{param}?" }

  def index
    build_event_query
    query_events
    @events = Event.where(id: @event_ids).in_order_of(:id, @event_ids)
    limit_events
    eager_load_events_associations

    build_title
  end

  private

  def build_title
    @title = if filtering_by_organizer_id?
      organizer = Organizer.find_by(id: event_query_params[:organizer_id])
      "Events by \"#{organizer.name}\"" if organizer.present?

    elsif filtering_by_location_id?
      location = Location.find_by(id: event_query_params[:location_id])
      "Events at \"#{location.city_address}\"" if location.present?

    elsif filtering_by_keywords?
      "Search results for \"#{event_query_params[:keywords]}\""

    elsif filtering_by_event_id?
      event = Event.find_by(id: event_query_params[:event_id])
      "Events similar to \"#{event.title}\"" if event.present?
    end

    @title ||= "Events"
  end

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
