class Bookmark::Event::Map::ListComponent < ViewComponent::Base
  delegate :relative_date, to: :helpers

  def initialize(events)
    @events = events
  end

  def events_by_date
    @events
      .sort_by { |event| [ event.start_date, event.start_time ] }
      .group_by { |event| event.start_date }
  end

  def time_zone
    (Current.city || Current.person.city).time_zone
  end
end
