class NextPersonalizedEventBatchBuilder
  include Rails.application.routes.url_helpers

  def initialize(city:, event_category:, time_period:, order_by:)
    @city = city
    @event_category = event_category
    @time_period = time_period
    @order_by = order_by
  end

  def build_events
    events = events_page_builder.build_events
    events.limit(EventBatch::BATCH_SIZE)
    events
  end

  private

  def events_page_builder
    @events_page_builder ||= Marketing::EventsPageBuilderFactory.build(
      city: @city,
      event_category: @event_category,
      time_period: @time_period,
      order_by: @order_by
    )
  end
end
