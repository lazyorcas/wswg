# TODO: this is too specific to event search - see "Rules" section.

class OpenAI::Assistants::SearchQueryBuilder
  INSTRUCTIONS = "You are a helpful assistant that builds search queries for a search engine."
  INPUT_TEMPLATE = <<-TEXT
    Build a search query from the following user input.

    ## Context
    Today is #{Date.today.strftime("%Y-%m-%d")}.
    Today is a #{Date.today.strftime("%A")}.
    The current time is #{Time.now.strftime("%H:%M")}.
    The current year is #{Date.today.year}.

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
    - The keywords should exclude information related to date, time, and price.
    - The keywords should exclude determiner words like "every", "all".

    ## Notes
    - It's possible that a date is not mentioned at all. Then, you can ignore the date related information.

    ## User Input
    %{text}
  TEXT

  def initialize
    @openai_responses_client = OpenAI::ResponsesClient.new
    @instructions = INSTRUCTIONS
    @input_template = INPUT_TEMPLATE
  end

  def build_search_query(text, json_schema:)
    input = build_input(text)
    @openai_responses_client.ask(
      input: input,
      instructions: @instructions,
      response_schema: json_schema
    )
  end

  private

  def build_input(text)
    @input_template % { text: text }
  end
end
