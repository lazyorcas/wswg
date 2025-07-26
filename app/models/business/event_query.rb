class Business::EventQuery
  include ActiveModel::Model
  include ActiveModel::Attributes

  LIMIT = 1000

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
      @events = Searchable::EventByKeywords.search(keywords)
    else
      @events = Event.joins(:city_source).where(city_sources: { city_id: city_id })
      filter_by_event if event_id.present?
    end

    filter_by_organizer if organizer_id.present?
    filter_by_location if location_id.present?
    filter_by_source if source_id.present?
    filter_by_dow if dow.present?
    filter_by_tod if tod.present?

    if event_id.present?
      order_by_relevance_to_event
    elsif keywords.blank?
      order_by_id
    end

    limit_events

    @events.pluck(:id)
  end

  def filter_by_event
    @events = @events.where("extended_keywords @@ to_tsquery(?)", event_title_keywords)
  end

  def filter_by_organizer
    @events = @events.where(organizer_id: organizer_id)
  end

  def filter_by_location
    @events = @events.joins(:location).where(locations: { id: location_id })
  end

  def filter_by_source
    @events = @events.joins(:city_source).where(city_sources: { source_id: source_id })
  end

  def filter_by_dow
    @events = @events.where(dow: dow)
  end

  def filter_by_tod
    if tod == "morning"
      @events = @events
        .where("start_time >= ?", "00:00:00")
        .where("start_time < ?", "12:00:00")
    elsif tod == "afternoon"
      @events = @events
        .where("start_time >= ?", "12:00:00")
        .where("start_time < ?", "18:00:00")
    elsif tod == "evening"
      @events = @events
        .where("start_time >= ?", "18:00:00")
        .where("start_time < ?", "23:59:59")
    end
  end

  def order_by_relevance_to_event
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [
      "ts_rank(extended_keywords, to_tsquery(?)) DESC",
      event_title_keywords
    ])
    @events = @events.order(Arel.sql(sql))
  end

  def order_by_id
    @events = @events.order(id: :desc)
  end

  def limit_events
    @events = @events.limit(LIMIT)
  end

  def event
    @event ||= Event.find(event_id)
  end

  def event_title_keywords
    @event_title_keywords ||= event.title
      .gsub(/[^a-zA-Z0-9]/, " ")
      .gsub(/\s+/, " ")
      .split(" ")
      .join(" | ")
  end
end
