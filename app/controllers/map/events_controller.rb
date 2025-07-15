class Map::EventsController < ApplicationController
  def show
    load_event
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end
end
