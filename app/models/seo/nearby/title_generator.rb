class SEO::Nearby::TitleGenerator
  FALLBACK_TITLE_TEMPLATES = {
    all: "%{event_category} near me",
    today: "🌇 %{event_category} near me today",
    tonight: "🌃 %{event_category} near me tonight",
    tomorrow: "🔜 %{event_category} near me tomorrow",
    this_week: "%{event_category} near me this week",
    this_weekend: "%{event_category} near me this weekend",
    next_week: "%{event_category} near me next week",
    next_weekend: "%{event_category} near me next weekend"
  }.freeze

  META_TITLE_DICTIONARY = {
    all: {
      today: "🌇 Local events near me today",
      tomorrow: "🔜 Local events near me tomorrow"
    }
  }.freeze

  def generate_title(event_category_symbol, time_period_symbol)
    FALLBACK_TITLE_TEMPLATES[time_period_symbol] % {
      event_category: EventCategory::SYMBOL_TO_STRING_MAPPING[event_category_symbol].humanize
    }
  end

  def generate_meta_title(event_category_symbol, time_period_symbol)
    META_TITLE_DICTIONARY.dig(event_category_symbol, time_period_symbol) || generate_title(event_category_symbol, time_period_symbol)
  end
end
