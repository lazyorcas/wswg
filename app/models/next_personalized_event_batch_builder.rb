class NextPersonalizedEventBatchBuilder
  include Rails.application.routes.url_helpers

  BATCH_SIZE = 10

  def initialize(city:, event_category:, time_period:, order_by:)
    @city = city
    @event_category = event_category
    @time_period = time_period
    @order_by = order_by
  end

  def build_events
    events = events_page_builder.build_events
    events.limit(BATCH_SIZE)
    events
  end

  def build_path
    next_personalized_event_batch_path(
      city_id: @city.id,
      event_category_slug: @event_category.slug,
      time_period_slug: @time_period.slug
    )
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
