class Event::FinalizeJob < ApplicationJob
  queue_as :default
  queue_with_priority 3
  limits_concurrency to: 1, key: ->(event_id) { event_id }, on_conflict: :discard

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 5.minutes, attempts: 3

  def perform(event_id)
    event = Event.find(event_id)

    event.fetch
    json = event.convert_markdown_to_json

    # to prevent overwriting the markdown
    if json["not_found"]
      event.reload
    else
      event.attendees_count = json["attendees_count"] == -1 ? nil : json["attendees_count"]
      event.organizer_url = json["organizer_url"].presence
    end

    event.attendees_count_finalized_at = Time.current

    event.save!
  end
end
