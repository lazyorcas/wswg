class Event::Search < Search
  default_scope { where(model_type: "Event") }

  private

  def build_keywords(query_object)
    query_object["keywords"]
      .gsub(/events?|things? to do/, "")
      .split(" ")
      .reject(&:blank?)
  end

  def build_conditions(query_object)
    # city = City.find_by(name: query_object.dig("city")) || user.city
    city = user.city
    today = Time.current.in_time_zone(city.time_zone).to_date

    query_start_date = query_object.dig("date_range", "start_date").presence
    if query_start_date.blank? || query_start_date < today.to_s
      query_start_date = today.to_s
    end

    {
      city_id: city.id,
      start_date: {
        lte: query_object.dig("date_range", "end_date").presence
      },
      end_date: {
        gte: query_start_date
      },
      start_time: {
        lte: query_object.dig("date_range", "end_time").presence
      },
      end_time: {
        gte: query_object.dig("date_range", "start_time").presence
      },
      price: {
        lte: query_object.dig("max_price") == -1 ? nil : query_object.dig("max_price")
      }
    }
  end

  def build_query_object
    event_curator.build_search_query(query,
      json_schema: json_schema,
      time_zone: user.city.time_zone
    )
  end

  def json_schema
    @json_schema ||= OpenAI::Responses::Schemas.event_search_query_schema
  end

  def event_curator
    @event_curator ||= OpenAI::Assistants::EventCurator.new
  end
end
