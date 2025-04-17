class Bookmark::Event::Map::ListComponent < ViewComponent::Base
  delegate :get_easy_date, to: :helpers
  attr_reader :events, :city

  def initialize(events, city:)
    @events = events
    @city = city
  end

  def events_by_date
    events
      .sort_by { |event| [ event.start_date, event.start_time ] }
      .group_by { |event| event.start_date }
  end
end
