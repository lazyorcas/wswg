class OpenAI::Assistants::EventCurator
  INSTRUCTIONS = "You are a helpful event curator that builds search queries for a search engine."
  INPUT_TEMPLATE = <<-TEXT
    Build a search query from the following user input.

    ## User Context
    The current date is %{current_date}.
    The current day of the week is %{current_dow}.
    The current time is %{current_time}.
    The current year is %{current_year}.

    ## Facts
    - Monday is the first day of the week with index 0.
    - Sunday is the last day of the week with index 6.
    - A week has 7 days.

    ## Date and Time Rules
    If/when a relative date is mentioned, please use these rules. It's safe to consider variations of these rules.
    - "today", "tomorrow", "yesterday" should have a date time range that covers the entire day.
    - "this week", "next week" should have a date time range that covers the entire week.
    - "this month", "next month" should have a date time range that covers the entire month.
    - "this year", "next year" should have a date time range that covers the entire year.
    - Start time should be 00:00:00 and end time should be 23:59:59.
    - It's possible to have a start date before the current date.

    ## Rules
    - The keywords should exclude information related to date, time, price (including "free").
    - The keywords should exclude determiner words like "every", "all".
    - The keywords should exclude adjectives.

    ## User Input
    %{text}
  TEXT

  def initialize
    @openai_responses_client = OpenAI::ResponsesClient.new
    @instructions = INSTRUCTIONS
    @input_template = INPUT_TEMPLATE
  end

  def build_search_query(text, json_schema:, time_zone:)
    input = build_input(text, time_zone: time_zone)
    @openai_responses_client.ask(
      input: input,
      instructions: @instructions,
      response_schema: json_schema
    )
  end

  private

  def build_input(text, time_zone:)
    now = Time.current.in_time_zone(time_zone)

    @input_template % {
      current_date: now.strftime("%Y-%m-%d"),
      current_dow: now.strftime("%A"),
      current_time: now.strftime("%H:%M"),
      current_year: now.year,
      text: text
    }
  end
end
