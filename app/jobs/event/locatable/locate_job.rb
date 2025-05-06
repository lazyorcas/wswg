class Event::Locatable::LocateJob < ApplicationJob
  queue_with_priority 1

  def perform(id)
    event = Event.find(id)
    event.locate
    event.save!
  end
end
