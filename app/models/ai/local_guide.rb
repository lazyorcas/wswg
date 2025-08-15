class AI::LocalGuide
  INSTRUCTIONS = <<~TEXT
    You are a local guide who's passionate about helping people find the best things to do in their city.

    You are an expert in building search queries for Elasticsearch, which you use to search fast and efficiently.
  TEXT

  BUILD_SEARCH_QUERY_INPUT_TEMPLATE = <<~TEXT
    You are a polygot in %{languages}.

    Build a search query or multiple search queries from the following user input, context, facts, and rules below. The facts and rules are in English. It's safe to consider variations of these rules in %{languages}, but retain the semantic meaning.

    ## User Input
    %{text}

    ## Keywords
    ### Rules
    - The keywords must exclude information related to date, time, location, and price (including "free").
    - The keywords must exclude determiner words like "every", "all".
    - The keywords must exclude adjectives.
    - The keywords must exclude generic words such as "event", "thing to do", "activity", and their plural forms.
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
    - The current date (in YYYY-MM-DD format) is %{current_date}.
    - The current time is %{current_time}.
    - The current day of the week is %{current_dow}.

    ### Facts
    - Monday is the first day of the week with index 0.
    - Sunday is the last day of the week with index 6.
    - A week has 7 days.

    ### Full-Day Rules
    It's safe to consider variations of these rules.
    - "today", "tomorrow", "yesterday" should have a date time range that covers the entire day.
    - "this week", "next week" should have a date time range that covers the entire week from Monday to Sunday.
    - "this month", "next month" should have a date time range that covers the entire month from the first day of the month to the last day of the month.
    - "this year", "next year" should have a date time range that covers the entire year from the first day of the year to the last day of the year.
    - Start time should be 00:00:00 and end time should be 23:59:59.

    ### Partial-Day Rules
    It's safe to consider variations of these rules.
    - "morning" should have a start time of 00:00:00 and an end time of 12:00:00.
    - "afternoon" should have a start time of 12:00:00 and an end time of 18:00:00.
    - "evening", "night" should have a start time of 18:00:00 and an end time of 23:59:59.
  TEXT

  def initialize
    @chat = Chat.create(model_id: "gpt-4.1-mini")
  end

  def build_search_query(text, now:, city_name:, languages:)
    input = BUILD_SEARCH_QUERY_INPUT_TEMPLATE % {
      current_date: now.strftime("%Y-%m-%d"),
      current_dow: now.strftime("%A"),
      current_time: now.strftime("%H:%M"),
      current_year: now.year,
      city_name: city_name,
      languages: languages,
      text: text
    }

    response = @chat
      .with_schema(SearchQuerySchema)
      .with_instructions(INSTRUCTIONS)
      .ask(input)
    response.content
  end

  DETECT_CITY_INPUT_TEMPLATE = <<~TEXT
    From the user input below, detect the city that the user is looking for.
    It's fine (and likely) if they are not mentioning the city.

    ## User Input
    %{text}
  TEXT

  def detect_city(text)
    input = DETECT_CITY_INPUT_TEMPLATE % { text: text }

    response = @chat
      .with_schema(CitySchema)
      .with_instructions(INSTRUCTIONS)
      .ask(input)
    response.content["city"]
  end
end
