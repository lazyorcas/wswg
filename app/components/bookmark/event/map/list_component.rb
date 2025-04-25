class Bookmark::Event::Map::ListComponent < ViewComponent::Base
  delegate :get_easy_date, to: :helpers
  attr_reader :events, :time_zone

  def initialize(events, time_zone:)
    @events = events
    @time_zone = time_zone
  end

  def events_by_date
    events
      .sort_by { |event| [ event.start_date, event.start_time ] }
      .group_by { |event| event.start_date }
  end
end
