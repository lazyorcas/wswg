class EventComponent < ViewComponent::Base
  delegate :get_easy_date, to: :helpers
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def city_source
    event.city_source
  end

  def source
    city_source.source
  end

  def city
    event.city_source.city
  end

  def url
    event.url
  end

  def image_url
    event.image_url
  end

  def title
    event.title
  end

  def start_date
    event.start_date
  end

  def end_date
    event.end_date
  end

  def date
    if start_date == end_date
      get_easy_date(Date.parse(start_date), time_zone: time_zone)
    else
      "#{get_easy_date(Date.parse(start_date), time_zone: time_zone)} - #{get_easy_date(Date.parse(end_date), time_zone: time_zone)}"
    end
  end

  def start_time
    event.start_time.to_time.strftime("%H:%M")
  end

  def end_time
    return nil if event.end_time.blank?

    event.end_time.to_time.strftime("%H:%M")
  end

  def time_range
    if end_time.blank?
      "#{start_time}"
    else
      "#{start_time} - #{end_time}"
    end
  end

  def source_icon_url
    "/sources/#{source.name.downcase}.ico"
  end

  def location
    event.location
  end

  def price
    event.price
  end

  def price_label
    if price.zero?
      "Free"
    else
      Money.from_amount(price, city.currency).format(no_cents: true)
    end
  end

  def time_zone
    event.time_zone
  end
end
