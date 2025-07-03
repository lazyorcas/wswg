class Home::Events::DescriptionsController < ApplicationController
  include BotProtection
  include CurrentPerson::Settings::PreferencesHelper

  protect_from_bots only: [ :show ]
  after_action :add_event_to_seen_events, only: [ :show ]

  def show
    load_event

    ahoy.track "Viewed event", event_id: @event.id, source: "description"
    sort_by_converted

    head(:ok)
  end

  private

  def load_event
    @event = event_scope.find(params[:id])
  end

  def add_event_to_seen_events
    Person::AddEventToSeenEventsJob.perform_later(
      person_type: Current.person.class.name,
      person_id: Current.person.id,
      event_id: @event.id
    )
  end

  def event_scope
    Event.all
  end
end
