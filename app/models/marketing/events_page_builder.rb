class Marketing::EventsPageBuilder
  include Marketing::SEO
  include Marketing::Events
  include Marketing::Events::SEO

  def initialize(city:, event_category:, time_period:, order_by: :time)
    @city = city
    @event_category = event_category
    @time_period = time_period
    @order_by = order_by
  end

  def build_path
    build_alternate_link_path(@time_period.to_sym)
  end
end
