class EventComponent < ViewComponent::Base
  include DateHelper

  attr_reader :event

  def initialize(event)
    @event = event
  end

  def url
    event.url
  end

  def title
    event.title
  end

  def date
    helpers.get_easy_date(Date.parse(event.start_date), time_zone: event.city.time_zone)
  end

  def start_time
    event.start_time.to_time.strftime("%H:%M")
  end

  def end_time
    event.end_time.to_time.strftime("%H:%M")
  end

  def time_range
    "#{start_time} - #{end_time}"
  end

  def source_icon_url
    event.city_source.icon_url || event.city_source.source.icon_url
  end

  def location
    event.location
  end
end
