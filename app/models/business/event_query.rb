class Business::EventQuery
  include ActiveModel::Model
  include ActiveModel::Attributes

  include QueryByKeywords
  include QueryByEvent
  include QueryByOrganizer
  include QueryByLocation

  attribute :city_id
  attribute :keywords
  attribute :event_id
  attribute :organizer_id
  attribute :location_id
  attribute :source_id
  attribute :month
  attribute :dow
  attribute :tod
  attribute :min_attendees_count
  attribute :max_attendees_count
  attribute :muted_keywords

  def initialize(attributes = {})
    super(attributes)
  end

  def query
    if keywords.present?
      query_by_keywords

    elsif event_id.present?
      query_by_event

    elsif organizer_id.present?
      query_by_organizer

    elsif location_id.present?
      query_by_location

    else
      @events = event_scope.order(id: :desc)

      filter_by_month if month.present?
      filter_by_dow if dow.present?
      filter_by_tod if tod.present?
      filter_by_min_attendees_count if min_attendees_count.present?
      filter_by_max_attendees_count if max_attendees_count.present?
      filter_by_source if source_id.present?
      filter_out_muted_keywords if muted_keywords.present?

      limit_events
    end

    @events
  end

  def event
    @event ||= Event.find(event_id)
  end

  def event_scope
    Event
      .joins(:city_source)
      .joins(:source)
      .joins(:organizer)
      .where(city_sources: { city_id: city_id })
      .where.not(sources: { name: "Ticketmaster" })
  end
end
