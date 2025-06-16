class CreateSearchQueriesJob < ApplicationJob
  HOUR_TO_QUERY = 7

  queue_as :default
  queue_with_priority 0

  def perform(skip_hour_check: false)
    City.enabled.find_each do |city|
      next if !skip_hour_check && city.time_zone.current_hour != HOUR_TO_QUERY

      EventCategory::SYMBOLS.each do |event_category_symbol|
        SearchQuery.create(
          city: city,
          query: EventCategory::SYMBOL_TO_STRING_MAPPING[event_category_symbol]
        )
      end
    end
  end
end
