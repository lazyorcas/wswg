class Event::UpdateAttendeesCountJob < ApplicationJob
  queue_as :default
  queue_with_priority 3
  limits_concurrency to: 5, key: ->(*) { self.class.name }

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 5.minutes, attempts: 3

  def perform(event_id)
    event = Event.find(event_id)

    event.fetch
    json = event.parse

    if json["attendees_count"].present? && json["attendees_count"].to_i > 0
      event.attendees_count = json["attendees_count"]
      event.save!
    end
  end
end
