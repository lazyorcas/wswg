class Business::EventQuery
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :city_id, :integer
  attribute :keywords, :string
  attribute :organizer_id, :integer
  attribute :dow, :integer
  attribute :tod, :string
  attribute :location_id, :string
  attribute :source_id, :integer

  def initialize(attributes = {})
    super(attributes)
  end

  def query
    @events = Event.joins(:city_source).where(city_sources: { city_id: city_id })

    filter_by_keywords if keywords.present?
    filter_by_organizer if organizer_id.present?
    filter_by_dow if dow.present?
    filter_by_tod if tod.present?
    filter_by_location if location_id.present?
    filter_by_source if source_id.present?

    if keywords.present?
      order_by_keywords_ranks
    else
      order_by_id
    end

    @events.pluck(:id)
  end

  private

  def filter_by_keywords
    @events = @events.where("extended_keywords @@ plainto_tsquery(?)", keywords)
  end

  def filter_by_organizer
    @events = @events.where(organizer_id: organizer_id)
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

  def filter_by_location
    @events = @events.joins(:location).where(locations: { id: location_id })
  end

  def filter_by_source
    @events = @events.where(source_id: source_id)
  end

  def order_by_id
    @events = @events.order(id: :desc)
  end

  def order_by_keywords_ranks
    sql = ActiveRecord::Base.send(:sanitize_sql_array, [
      "ts_rank(extended_keywords, plainto_tsquery(?)) DESC",
      keywords
    ])
    @events = @events.order(Arel.sql(sql))
  end
end
