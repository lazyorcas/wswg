class Home::EventBatchesController < ApplicationController
  def show
    build_event_batch
    load_events
    eager_load_events_associations
  end

  private

  def build_event_batch
    @event_batch = EventBatch.new(event_batch_params[:event_ids])
  end

  def load_events
    @events = @event_batch.load_events
  end

  def eager_load_events_associations
    @events = @events.includes(:source, :location, :city)
  end

  def event_batch_params
    params.permit(event_ids: [])
  end
end
