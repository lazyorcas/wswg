class SEO::City::TitleGenerator
  FALLBACK_META_TITLE_TEMPLATES = {
    all: "%{event_category} in %{city}",
    today: "🌇 %{event_category} today in %{city}",
    tonight: "🌃 %{event_category} tonight in %{city}",
    tomorrow: "🔜 %{event_category} tomorrow in %{city}",
    this_week: "%{event_category} this week in %{city}",
    this_weekend: "%{event_category} this weekend in %{city}",
    next_week: "%{event_category} next week in %{city}",
    next_weekend: "%{event_category} next weekend in %{city}"
  }.freeze

  META_TITLE_DICTIONARY = {
    "San Francisco" => {
      events: {
        all: "San Francisco events",
        today: "🌇 San Francisco events today",
        this_week: "Things to do this week in San Francisco",
        this_weekend: "San Francisco events this weekend"
      },
      concerts: {
        this_week: "Concerts in San Francisco this week"
      }
    },
    "London" => {
      events: {
        all: "Events in London",
        today: "🌇 Events in London today",
        tomorrow: "🔜 London events tomorrow",
        this_week: "Events in London this week",
        next_week: "Events in London next week"
      },
      concerts: {
        tonight: "Concerts on tonight in London"
      }
    },
    "New York City" => {
      events: {
        all: "New York events",
        today: "🌇 NYC events today",
        tomorrow: "🔜 NYC things to do tomorrow",
        this_week: "Events in New York this week",
        this_weekend: "New York City happenings this weekend",
        next_week: "Next week in New York"
      },
      meetups: {
        all: "NYC Meetups"
      }
    },
    "Singapore" => {
      events: {
        all: "Singapore events",
        today: "🌇 Events in Singapore today"
      }
    },
    "Berlin" => {
      events: {
        today: "🌇 Events in Berlin today",
        tomorrow: "🔜 Tomorrow in Berlin",
        this_week: "This week Berlin"
      },
      concerts: {
        all: "Concerts Berlin"
      }
    },
    "Barcelona" => {
      events: {
        all: "Barcelona events",
        today: "🌇 Barcelona events today"
      }
    },
    "Paris" => {
      events: {
        today: "🌇 Paris events today",
        tomorrow: "🔜 Paris tomorrow",
        this_week: "Paris events this week"
      },
      concerts: {
        next_week: "Concerts in Paris next week"
      }
    },
    "Munich" => {
      events: {
        all: "Munich events",
        today: "🌇 Munich events today"
      }
    },
    "Lisbon" => {
      events: {
        all: "Lisbon events",
        today: "🌇 Lisbon events today",
        tonight: "🌃 Tonight in Lisbon"
      }
    },
    "Hamburg" => {
      concerts: {
        all: "Hamburg concerts"
      }
    }
  }.freeze

  FALLBACK_TITLE_TEMPLATE = "What %{event_category} are happening in %{city} %{time_period}?".freeze

  TITLE_DICTIONARY = {
    events: "What's happening in %{city} %{time_period}?"
  }.freeze

  def generate_meta_title(city_name, event_category_symbol, time_period_symbol)
    META_TITLE_DICTIONARY.dig(city_name, event_category_symbol, time_period_symbol) ||
      FALLBACK_META_TITLE_TEMPLATES[time_period_symbol] % {
        event_category: EventCategory::SYMBOL_TO_STRING_MAPPING[event_category_symbol].humanize,
        city: city_name
      }
  end

  def generate_title(city_name, event_category_symbol, time_period_symbol)
    title = (TITLE_DICTIONARY.dig(event_category_symbol) || FALLBACK_TITLE_TEMPLATE) % {
      event_category: EventCategory::SYMBOL_TO_STRING_MAPPING[event_category_symbol],
      city: city_name,
      time_period: time_period_symbol == :all ? nil : time_period_symbol.to_s.humanize.downcase
    }

    title.gsub!(/  +/, " ")
    title.gsub!(/ \?/, "?")
    title
  end
end
