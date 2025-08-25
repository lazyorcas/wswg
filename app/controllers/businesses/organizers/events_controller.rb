class Businesses::Organizers::EventsController < ApplicationController
  include BusinessesOnly

  layout "businesses"

  def index
    load_events
    order_events
  end

  private

  def load_events
    @events = event_scope
  end

  def order_events
    @events = @events.order(start_date: :desc, start_time: :desc)
  end

  def event_scope
    Event.where(organizer: Current.business.organizer)
  end
end
