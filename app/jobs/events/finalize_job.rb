class Events::FinalizeJob < ApplicationJob
  queue_as :default
  queue_with_priority 0

  def perform
    Event
      .joins(:source)
      .where(source: { events_finalizable: true })
      .where("finalizable_from IS NOT NULL AND finalizable_until IS NOT NULL")
      .where("NOW() BETWEEN finalizable_from AND finalizable_until")
      .find_each do |event|
        Event::UpdateAttendeesCountJob.perform_later(event.id)
      end
  end
end
