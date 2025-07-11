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
    attendees_count = event.extract_attendees_count_from_markdown

    if attendees_count >= 0
      event.attendees_count = attendees_count
    else
      event.attendees_count = nil
    end
    event.attendees_count_finalized_at = Time.current if event.has_started?

    event.save!
  end
end
