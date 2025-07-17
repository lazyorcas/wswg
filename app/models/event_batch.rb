class EventBatch
  BATCH_SIZE = 10

  def initialize(event_ids)
    @event_ids = event_ids
  end

  def load_events
    @events = Event
      .where(id: @event_ids)
      .in_order_of(:id, @event_ids)
      .limit(BATCH_SIZE)
  end
end
