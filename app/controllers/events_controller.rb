class EventsController < ApplicationController
  helper_method :show_context

  def show
    load_event
  end

  private

  def show_context
    params[:context]
  end

  def load_event
    @event = Event.find(params[:id])
  end
end
