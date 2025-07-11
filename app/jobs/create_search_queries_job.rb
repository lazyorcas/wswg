class CreateSearchQueriesJob < ApplicationJob
  HOUR_TO_QUERY = 7

  queue_as :default
  queue_with_priority 0

  def perform(skip_hour_check: false)
    event_category_symbols = EventCategory::SYMBOLS - [ :events ]
    event_categories = event_category_symbols.map { |symbol| EventCategory.new(symbol) }

    City.enabled.find_each do |city|
      next if !skip_hour_check && city.time_zone.current_hour != HOUR_TO_QUERY

      event_categories.each do |event_category|
        SearchQuery.create(
          city: city,
          query: event_category.query
        )
      end
    end
  end
end
