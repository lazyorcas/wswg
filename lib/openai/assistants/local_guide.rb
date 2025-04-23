class OpenAI::Assistants::LocalGuide
  INSTRUCTIONS_TEMPLATE = <<-TEXT
    You are a local guide who's passionate about helping people find the best things to do in their city.

    You are an expert in building search queries for Elasticsearch, which you use to search fast and efficiently.
  TEXT

  BUILD_SEARCH_QUERY_INPUT_TEMPLATE = <<-TEXT
    You are a polygot in %{languages}.

    Build a search query or multiple search queries from the following user input, context, facts, and rules below. The facts and rules are in English. It's safe to consider variations of these rules in %{languages}, but retain the semantic meaning.

    ## User Input
    %{text}

    ## Keywords
    ### Rules
    - The keywords must exclude information related to date, time, location, and price (including "free").
    - The keywords must exclude determiner words like "every", "all".
    - The keywords must exclude adjectives.
    - The keywords must exclude generic words such as "event", "thing to do", and their plural forms.
    - The keywords must exclude the city name: %{city_name}.
    - The keywords must not include information that is not in the user input.
    - It's perfectly fine for the keywords to be empty.

    ### Languages
    - For each language from this list: %{languages}, you must build keywords for that language. You can always start with the English keywords and then translate them.
    - The meaning of the keywords must be the same in all languages.
    - It's fine if no language has keywords.
    - It's not fine if only some languages have keywords.

    ## Date Time
    If a time-sensitive keyword is mentioned, please use the section below to build the date time range.

    ### User's Context
    - The current date is %{current_date}.
    - The current day of the week is %{current_dow}.
    - The current time is %{current_time}.
    - The current year is %{current_year}.

    ### Facts
    - Monday is the first day of the week with index 0.
    - Sunday is the last day of the week with index 6.
    - A week has 7 days.

    ### Full-Day Rules
    It's safe to consider variations of these rules.
    - "today", "tomorrow", "yesterday" should have a date time range that covers the entire day.
    - "this week", "next week" should have a date time range that covers the entire week.
    - "this month", "next month" should have a date time range that covers the entire month.
    - "this year", "next year" should have a date time range that covers the entire year.
    - Start time should be 00:00:00 and end time should be 23:59:59.

    ### Partial-Day Rules
    It's safe to consider variations of these rules.
    - "morning" should have a start time of 00:00:00 and an end time of 12:00:00.
    - "afternoon" should have a start time of 12:00:00 and an end time of 18:00:00.
    - "evening", "night" should have a start time of 18:00:00 and an end time of 23:59:59.
  TEXT

  def initialize
    @openai_responses_client = OpenAI::ResponsesClient.new
  end

  def build_search_query(text, city_name:, time_zone:, languages:)
    instructions = INSTRUCTIONS_TEMPLATE

    now = Time.current.in_time_zone(time_zone)
    input = BUILD_SEARCH_QUERY_INPUT_TEMPLATE % {
      current_date: now.strftime("%Y-%m-%d"),
      current_dow: now.strftime("%A"),
      current_time: now.strftime("%H:%M"),
      current_year: now.year,
      city_name: city_name,
      languages: languages,
      text: text
    }

    @openai_responses_client.ask(
      input: input,
      instructions: instructions,
      response_schema: OpenAI::Responses::Schemas.search_query_schema,
      model: "gpt-4.1-mini"
    )
  end

  DETECT_CITY_INPUT_TEMPLATE = <<-TEXT
    From the user input below, detect the city that the user is looking for. It's possible that they are not mentioning the city by name.

    ## User Input
    %{text}
  TEXT

  def detect_city(text)
    instructions = INSTRUCTIONS_TEMPLATE
    input = DETECT_CITY_INPUT_TEMPLATE % { text: text }

    @openai_responses_client.ask(
      input: input,
      instructions: instructions,
      response_schema: OpenAI::Responses::Schemas.city_schema
    )
  end
end
