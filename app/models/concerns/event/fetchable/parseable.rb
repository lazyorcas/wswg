module Event::Fetchable::Parseable
  extend ActiveSupport::Concern

  included do
    attr_reader :json
  end

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
    - It's possible that there are multiple dates mentioned. You should only focus on the highlighted date.
  TEXT

  private

  def parse
    @json = markdown_expert.convert_to_json(
      markdown,
      context: CONTEXT % { current_year: today.year },
      json_schema: json_schema
    )

    @json = nil if @json["not_found"]

    self.attributes = @json.slice(*self.class.column_names)
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
end
