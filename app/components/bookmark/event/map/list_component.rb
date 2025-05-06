class Bookmark::Event::Map::ListComponent < ViewComponent::Base
  delegate :relative_date, to: :helpers

  def initialize(events, time_zone:)
    @events = events
    @time_zone = time_zone
  end

  def events_by_date
    @events
      .sort_by { |event| [ event.start_date, event.start_time ] }
      .group_by { |event| event.start_date }
  end
end
