class Event::FinalizeAttendeesCountJob < ApplicationJob
  queue_as :default
  queue_with_priority 3
  limits_concurrency to: 1, key: ->(event_id) { event_id }, on_conflict: :discard

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 5.minutes, attempts: 3

  retry_on Event::UrlNotFoundError, wait: 1.hour, attempts: 3

  def perform(event_id)
    event = Event.find(event_id)

    event.fetch
    attendees_count = event.extract_attendees_count_from_markdown

    raise Event::UrlNotFoundError.new(event.url) if attendees_count == -1

    event.attendees_count = attendees_count
    event.attendees_count_finalized_at = Time.current

    event.save!
  end
end
