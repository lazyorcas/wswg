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
  attribute :dow
  attribute :tod

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

      filter_by_dow if dow.present?
      filter_by_tod if tod.present?
      filter_by_source if source_id.present?

      limit_events
    end

    @events
  end

  def event
    @event ||= Event.find(event_id)
  end

  def event_scope
    Event.joins(:city_source).where(city_sources: { city_id: city_id })
  end
end
