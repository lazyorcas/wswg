module Event::Fetchable
  extend ActiveSupport::Concern

  CONTEXT = <<~TEXT
    This markdown should be about an event.

    ## Rules
    - Please don't assume information that is not mentioned in this markdown.

    ## Facts
    - The current year is %{current_year}.
    - The end date is always after the start date.

    ## Keep in mind
    - It's possible that the event has already expired or not found.
    - It's possible that year is not mentioned. In this case, use the current year.
    - Important! It's possible that the end date is not mentioned. In this case, the end date is the same as the start date.
  TEXT

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
      errors.add(:url, "is not found or expired")
      return
    end

    if json["location"].present?
      if city.precise?(json["location"])
        self.location_query = json["location"]

      elsif !city.contains?(json["location"])
        self.location_query = "#{json["location"]}, #{city.name}"
      end
    end
  end

  private

  def json_schema
    OpenAI::Responses::Schemas.event_schema
  end

  def jina_reader
    @jina_reader ||= Jina::Reader.new
  end

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end
end
