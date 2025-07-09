class Map::EventsController < ApplicationController
  include CurrentPerson::Settings::PreferencesHelper

  after_action :add_event_to_seen_events, only: [ :show ], if: -> { Current.person.persisted? }

  def show
    load_event

    ahoy.track "Viewed event", event_id: @event.id, source: "map"
    sort_by_converted
  end

  private

  def load_event
    @event = Event.find(params[:id])
  end

  def add_event_to_seen_events
    Person::AddEventToSeenEventsJob.perform_later(
      person_type: Current.person.class.name,
      person_id: Current.person.id,
      event_id: @event.id
    )
  end

  def event_scope
    Event
      .joins(:city)
      .where(city: { id: @city.id })
  end
end
