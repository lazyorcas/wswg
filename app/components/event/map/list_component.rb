class Event::Map::ListComponent < ViewComponent::Base
  attr_reader :events, :bookmarked_event_ids, :seen_event_ids

  def initialize(events, bookmarked_event_ids:, seen_event_ids:)
    @events = events
    @bookmarked_event_ids = bookmarked_event_ids
    @seen_event_ids = seen_event_ids
  end
end
