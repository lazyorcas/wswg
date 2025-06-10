class Person::AddEventToSeenEventsJob < ApplicationJob
  queue_as :default

  def perform(person_type:, person_id:, event_id:)
    person = person_type.constantize.find(person_id)
    return if person.seen_event_ids.include?(event_id)

    event = Event.find(event_id)
    person.seen_events << event
    person.save!
  end
end
