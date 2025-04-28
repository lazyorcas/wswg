module Event::Fetchable
  extend ActiveSupport::Concern

  CONTEXT = <<~TEXT
    This markdown should be about an event.

    ## Rules
    - Please don't assume information that is not mentioned in this markdown.
    - The start time and end time cannot be the same.

    ## Facts
    - The current year is %{current_year}.
    - The end date is always after the start date.

    ## Keep in mind
    - It's possible that the event has already expired or not found.
    - It's possible that year is not mentioned. In this case, use the current year.
    - Important! It's possible that the end date is not mentioned. In this case, the end date is the same as the start date.
  TEXT

  included do
    validate :validate_openai_not_hallucinated, if: -> { end_date.present? }
  end

  def found?
    @found
  end

  def fetch
    @markdown ||= jina_reader.fetch(url)
  end

  def parse
    json = markdown_expert.convert_to_json(
      @markdown,
      context: CONTEXT % {
        current_year: Time.current.in_time_zone(city.time_zone).year
      },
      json_schema: json_schema
    )

    self.attributes = json.slice(*self.class.column_names)

    if json["not_found"]
      @found = false
      return
    end

    @found = true

    set_location_query(json["location"]) if json["location"].present?
  end

  def openai_hallucinated?
    first_day_of_year = "#{today_in_city_timezone.year}-01-01"
    end_date == first_day_of_year && today_in_city_timezone != first_day_of_year
  end

  private

  def validate_openai_not_hallucinated
    return if !openai_hallucinated?

    errors.add(:base, :openai_hallucinated)
  end

  def set_location_query(location_query)
    if precise_location?(location_query)
      self.location_query = location_query

    elsif !city.contains?(location_query)
      self.location_query = "#{location_query}, #{city.name}"
    end
  end

  def precise_location?(query)
    !location_is_city?(query)
  end

  def location_is_city?(query)
    geographer.true_or_false?(
      location: query,
      question: "Is the location a city?"
    )
  end

  def json_schema
    OpenAI::Responses::Schemas.event_schema
  end

  def jina_reader
    @jina_reader ||= Jina::Reader.new
  end

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end

  def geographer
    @geographer ||= OpenAI::Assistants::Geographer.new
  end
end
