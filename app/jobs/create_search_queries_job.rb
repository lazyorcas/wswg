class CreateSearchQueriesJob < ApplicationJob
  HOUR_TO_QUERY = 7

  queue_as :default
  queue_with_priority 0

  def perform(skip_hour_check: false)
    City.enabled.find_each do |city|
      next if !skip_hour_check && city.time_zone.current_hour != HOUR_TO_QUERY

      EventCategory::SYMBOLS.each do |event_category_symbol|
        next if event_category_symbol == :events

        SearchQuery.create(
          city: city,
          query: EventCategory.new(event_category_symbol).query
        )
      end
    end
  end
end
