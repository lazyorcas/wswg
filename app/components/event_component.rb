class EventComponent < ViewComponent::Base
  attr_reader :event

  def initialize(event)
    @event = event
  end

  def price_label
    if event.price.zero?
      "Free"
    else
      "$#{event.price}"
    end
  end
end
