class EventComponent < ViewComponent::Base
  delegate :relative_date, to: :helpers

  def initialize(event)
    @event = event
  end

  def date
    dates = [ @event.start_date, @event.end_date ].uniq.map do |date|
      relative_date(date, @event.start_time, time_zone: @event.time_zone)
    end

    dates.join(" - ")
  end

  def start_time
    @event.start_time.to_time.strftime("%H:%M")
  end

  def end_time
    return nil if @event.end_time.blank?

    @event.end_time.to_time.strftime("%H:%M")
  end

  def time_range
    [ start_time, end_time ].compact.join(" - ")
  end

  def source_icon_url
    "/sources/#{@event.source.name.underscore}.ico"
  end

  def price_label
    price = @event.price

    if price.zero?
      "Free"
    else
      "#{@event.city.currency} #{@event.price}"
    end
  end
end
