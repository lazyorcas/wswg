class EventBatch
  BATCH_SIZE = 10

  def initialize(event_ids)
    @event_ids = event_ids
  end

  def build_events
    load_events
    order_events
    @events = @events.limit(BATCH_SIZE)
    @events
  end

  private

  def load_events
    @events = Event.where(id: @event_ids)
  end

  def order_events
    @events = @events.in_order_of(:id, @event_ids)
  end
end
