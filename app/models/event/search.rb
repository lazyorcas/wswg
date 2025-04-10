class Event::Search < Search
  private

  def searchable_model
    Event
  end

  def build_keywords(query_object)
    query_object["keywords"]
      .split(" ")
      .reject { |keyword| keyword.include?("event") }
  end

  def build_conditions(query_object)
    query_start_date = query_object.dig("date_range", "start_date").presence
    if query_start_date.blank? || query_start_date < today_iso8601
      query_start_date = today_iso8601
    end

    max_price = query_object.dig("max_price")

    city_id = City.find_by(name: query_object.dig("city"))&.id || user.city_id

    {
      city_id: city_id,
      start_date: {
        gte: query_start_date,
        lte: query_object.dig("date_range", "end_date").presence
      },
      start_time: {
        gte: query_object.dig("date_range", "start_time").presence,
        lte: query_object.dig("date_range", "end_time").presence
      },
      price: {
        lte: max_price == -1 ? nil : max_price
      }
    }
  end

  def today_iso8601
    Time.current.in_time_zone(time_zone).strftime("%Y-%m-%d")
  end

  def build_query_object
    event_curator.build_search_query(query,
      json_schema: json_schema,
      time_zone: time_zone
    )
  end

  def json_schema
    @json_schema ||= OpenAI::Responses::Schemas.event_search_query_schema
  end

  def event_curator
    @event_curator ||= OpenAI::Assistants::EventCurator.new
  end

  def time_zone
    @time_zone ||= user.city.time_zone
  end
end
