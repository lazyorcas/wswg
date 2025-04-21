class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  retry_on Net::ReadTimeout, wait: :polynomially_longer, attempts: 3

  def perform(attributes)
    event = Event.new(attributes)
    event.fetch
    event.locate

    if event.valid?
      event.save!
    else
      raise "Event is not valid: #{event.errors.full_messages.to_sentence}"
    end
  end
end
