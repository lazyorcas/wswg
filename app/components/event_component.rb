class EventComponent < ViewComponent::Base
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

  def image_url
    event.image_url
  end

  def date
    event.start_date.to_date.strftime("%A, %B %d")
  end

  def time
    event.start_time.to_time.strftime("%I:%M %p")
  end

  def price_label
    if event.price.zero?
      "Free"
    else
      "$#{event.price}"
    end
  end
end
