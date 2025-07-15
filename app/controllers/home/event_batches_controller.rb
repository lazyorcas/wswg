class Home::EventBatchesController < ApplicationController
  def show
    build_event_batch
    build_events
    @events = @events.includes(:source, :location, :city)
  end

  private

  def build_event_batch
    @event_batch = EventBatch.new(event_batch_params[:event_ids])
  end

  def build_events
    @events = @event_batch.build_events
  end

  def event_batch_params
    params.permit(event_ids: [])
  end
end
