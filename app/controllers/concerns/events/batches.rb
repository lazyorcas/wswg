module Events::Batches
  extend ActiveSupport::Concern

  def limit_events_to_batch_size
    @events = @events.limit(EventBatch::BATCH_SIZE)
  end

  def split_events_into_batches
    @event_batches = @events.in_batches(of: EventBatch::BATCH_SIZE)
  end
end
