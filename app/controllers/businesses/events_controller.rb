class Businesses::EventsController < ApplicationController
  PERMITTED_PARAMS = %i[keywords event_id organizer_id location_id source_id dow tod month min_attendees_count max_attendees_count]

  include BusinessesOnly

  layout "businesses"
  helper_method :event_query_params, *PERMITTED_PARAMS.map { |param| "filtering_by_#{param}?" }, :filtering_by_date?, :filtering_by_attendees_count?

  def index
    ahoy.track "Business - Viewed events", **event_query_params

    build_event_query
    query_events
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

  def filtering_by_date?
    filtering_by_month? || filtering_by_dow?
  end

  def filtering_by_attendees_count?
    filtering_by_min_attendees_count? || filtering_by_max_attendees_count?
  end

  def build_event_query
    @event_query = Business::EventQuery.new(
      city_id: Current.business.city_id,
      **event_query_params
    )
  end

  def query_events
    @events = @event_query.query
  end

  def eager_load_events_associations
    @events = @events.includes(:source, :location, :city, :organizer)
  end

  def event_query_params
    params.permit(*PERMITTED_PARAMS)
  end
end
