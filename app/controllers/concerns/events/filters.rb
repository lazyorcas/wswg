module Events::Filters
  extend ActiveSupport::Concern

  def load_event_category
    @event_category = EventCategory.new(event_category_symbol)
  end

  def load_time_period
    @time_period = TimePeriod.new(@city.time_zone, time_period_symbol)
  end

  private

  def event_category_symbol
    raise NotImplementedError
  end

  def time_period_symbol
    raise NotImplementedError
  end
end
