module Event::Fetchable::Parseable
  extend ActiveSupport::Concern

  CONTEXT = <<~TEXT
    This markdown should be about an event.

    ## Rules
    - Please don't assume information that is not mentioned in this markdown.
    - The start time and end time cannot be the same.

    ## Facts
    - The current year is %{current_year}.
    - The end date is after the start date.

    ## Keep in mind
    - It's possible that the event has already expired or not found.
    - It's possible that year is not mentioned. In this case, use the current year.
    - Important! It's possible that the end date is not mentioned. In this case, the end date is the same as the start date.
  TEXT

  included do
    validate :validate_openai_not_hallucinated, if: -> { end_date.present? }
  end

  private

  def parsed?
    @parsed
  end

  def parse
    json = markdown_expert.convert_to_json(
      markdown,
      context: CONTEXT % { current_year: today.year },
      json_schema: json_schema
    )

    raise OpenAI::HallucinationError if openai_hallucinated?

    if json["not_found"]
      @parsed = false
      return
    end

    self.attributes = json.slice(*self.class.column_names)
    @parsed = true
  end

  def markdown
    raise NotImplementedError
  end

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end

  def json_schema
    OpenAI::Responses::Schemas.event_schema
  end

  def openai_hallucinated?
    first_day_of_year = "#{today.year}-01-01"
    end_date == first_day_of_year && today != first_day_of_year
  end
end
