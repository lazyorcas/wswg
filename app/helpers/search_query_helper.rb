module SearchQueryHelper
  PLACEHOLDER_TEMPLATES = [
    "free comedy shows this Sunday",
    "indie concerts this month",
    "football tonight",
    "ai events tomorrow",
    "meetup next week",
    "speed dating this weekend",
    "outdoor sports next weekend",
    "what's happening in Singapore next week",
    "live concerts",
    "all events today"
  ].freeze

  def generate_search_query_placeholder
    "e.g. #{PLACEHOLDER_TEMPLATES.sample}"
  end
end
