module Event::Parseable
  extend ActiveSupport::Concern

  CONTEXT = <<~TEXT
    This markdown should be about an event.

    ## Rules
    - Please don't assume information that is not mentioned in this markdown.

    ## Facts
    - The current date (in YYYY-MM-DD format) is %{current_date}.
    - The current year is %{current_year}.
    - The end date is after the start date.
    - The start time and end time cannot be the same.

    ## Keep in mind
    - It's possible that the event has already expired or not found.
    - It's possible that year is not mentioned. In this case, if the event's day-month combination is before the current date's day-month combination, the year is the next year. Otherwise, it's the current year.
    - It's possible that the end date is not mentioned. In this case, the end date is the same as the start date.
    - It's possible that there are multiple dates mentioned. You should only focus on the highlighted date.
  TEXT

  def parse
    json = markdown_expert.convert_to_json(
      markdown,
      context: CONTEXT % {
        current_date: time_zone.current_date,
        current_year: time_zone.current_year
      },
      json_schema: json_schema
    )

    if json["not_found"]
      archived_link = ArchivedLink.find_or_initialize_by(url: url)

      if archived_link.new_record?
        archived_link.reason = :not_found_or_expired
        archived_link.metadata = {
          markdown: markdown,
          json: json
        }
        archived_link.save!
      end
      return
    end

    self.attributes = json.slice(*self.class.column_names)
    self.location_query = json["location"].presence
  end

  private

  def markdown_expert
    @markdown_expert ||= OpenAI::Assistants::MarkdownExpert.new
  end

  def json_schema
    OpenAI::Responses::Schemas.event_schema
  end
end
