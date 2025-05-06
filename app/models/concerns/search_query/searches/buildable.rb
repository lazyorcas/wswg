module SearchQuery::Searches::Buildable
  extend ActiveSupport::Concern

  def build_searches
    searches.build(searches_attributes)
  end

  private

  def searches_attributes
    @searches_attributes ||= language_keywords.map do |language, keywords|
      {
        searchable_event_type: "Searchable::#{language.capitalize}Event",
        keywords: keywords,
        conditions: search_conditions
      }
    end
  end

  def query_object
    @query_object ||= local_guide.build_search_query(
      query,
      now: city.time_zone.now,
      city_name: city.name,
      languages: city.languages.pluck(:name)
    )
  end

  def language_keywords
    @language_keywords ||= begin
      lks = {}

      query_object["language_keywords"].each do |language_keyword|
        keywords_arr = language_keyword["keywords"]
          .split(" ")
          .reject(&:blank?)

        keywords_arr << "*" if keywords_arr.empty?
        keywords = keywords_arr.join(" ")

        lks[language_keyword["language"]] = keywords
      end

      if lks.select { |_, keywords| keywords == "*" }.length == lks.length
        lks = { "English" => "*" }

      elsif lks.select { |_, keywords| keywords == "*" }.length > 1
        Sentry.capture_message(
          "Some keywords are empty",
          level: :warning,
          extra: { search_query_id: id }
        )

        lks = lks.reject { |_, keywords| keywords == "*" }
      end

      lks
    end
  end

  def search_conditions
    @search_conditions ||= begin
      {
        location: {
          near: city.coordinates,
          within: "#{Event::Locatable::MAX_DISTANCE_TO_CITY}#{Event::Locatable::DISTANCE_UNIT}"
        },
        end_date: {
          gte: query_object.dig("date_range", "start_date").presence,
          lte: query_object.dig("date_range", "end_date").presence
        },
        start_time: {
          gte: query_object.dig("date_range", "start_time").presence,
          lte: query_object.dig("date_range", "end_time").presence
        },
        price: {
          lte: query_object["max_price"] == -1 ? nil : query_object["max_price"]
        }
      }
    end
  end

  def city
    @city ||= begin
      city_response = local_guide.detect_city(query)
      city_name = city_response["city"]

      if city_name == "NOT_SUPPORTED"
        Sentry.capture_message(
          "Location not supported",
          level: :warning,
          extra: { search_id: id }
        )

        raise UserReadableError.new(
          "This location is not supported yet. Only #{City.pluck(:name).to_sentence} are currently supported."
        )
      end

      City.find_by(name: city_name) || user.city
    end
  end

  def local_guide
    @local_guide ||= OpenAI::Assistants::LocalGuide.new
  end
end
