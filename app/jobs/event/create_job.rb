class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  retry_on Net::ReadTimeout, wait: :polynomially_longer, attempts: 3

  def perform(attributes)
    event = Event.new(attributes)
    event.fetch
    event.locate
    event.save!
  end
end
