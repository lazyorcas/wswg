class SEO::City::TitleGenerator
  FALLBACK_TITLE_TEMPLATES = {
    all: "Events in %{city}",
    today: "Events today in %{city}",
    tonight: "Events tonight in %{city}",
    tomorrow: "Events tomorrow in %{city}",
    this_week: "Events this week in %{city}",
    this_weekend: "Events this weekend in %{city}",
    next_week: "Events next week in %{city}",
    next_weekend: "Events next weekend in %{city}"
  }.freeze

  TITLE_DICTIONARY = {
    "San Francisco" => {
      all: "San Francisco events",
      today: "San Francisco events today",
      this_week: "Things to do this week in San Francisco",
      this_weekend: "San Francisco events this weekend"
    },
    "London" => {
      today: "Events in London today",
      tomorrow: "London events tomorrow",
      this_week: "Events in London this week",
      next_week: "Events in London next week"
    },
    "New York City" => {
      all: "New York events",
      today: "NYC events today",
      tomorrow: "NYC things to do tomorrow",
      this_week: "Events in New York this week",
      this_weekend: "New York City happenings this weekend",
      next_week: "Next week in New York"
    },
    "Singapore" => {
      all: "Singapore events",
      today: "Events in Singapore today"
    },
    "Berlin" => {
      today: "Events in Berlin today",
      tomorrow: "Tomorrow in Berlin",
      this_week: "This week Berlin"
    },
    "Barcelona" => {
      all: "Barcelona events",
      today: "Barcelona events today"
    },
    "Paris" => {
      today: "Paris events today",
      tomorrow: "Paris tomorrow",
      this_week: "Paris events this week"
    },
    "Munich" => {
      all: "Munich events",
      today: "Munich events today"
    },
    "Lisbon" => {
      all: "Lisbon events",
      today: "Lisbon events today",
      tonight: "Tonight in Lisbon"
    }
  }.freeze

  def generate_default_title(city, time_period_symbol)
    FALLBACK_TITLE_TEMPLATES[time_period_symbol] % { city: city.name }
  end

  def generate_title(city, time_period_symbol)
    TITLE_DICTIONARY.dig(city.name, time_period_symbol) ||
      FALLBACK_TITLE_TEMPLATES[time_period_symbol] % { city: city.name }
  end
end
