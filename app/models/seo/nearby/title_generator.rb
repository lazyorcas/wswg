class SEO::Nearby::TitleGenerator
  META_TITLE_DICTIONARY = {
    all: "Events near me",
    today: "🌇 Local events near me today",
    tonight: "🌃 Events near me tonight",
    tomorrow: "🔜 Local events near me tomorrow",
    this_week: "Events near me this week",
    this_weekend: "Events near me this weekend",
    next_week: "Events near me next week",
    next_weekend: "Events near me next weekend"
  }.freeze

  TITLE_DICTIONARY = {
    all: "Events near me",
    today: "🌇 Events near me today",
    tonight: "🌃 Events near me tonight",
    tomorrow: "🔜 Events near me tomorrow",
    this_week: "Events near me this week",
    this_weekend: "Events near me this weekend",
    next_week: "Events near me next week",
    next_weekend: "Events near me next weekend"
  }.freeze

  def generate_meta_title(time_period_symbol)
    META_TITLE_DICTIONARY[time_period_symbol]
  end

  def generate_title(time_period_symbol)
    TITLE_DICTIONARY[time_period_symbol]
  end
end
