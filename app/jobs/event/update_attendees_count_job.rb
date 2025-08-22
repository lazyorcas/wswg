class Event::UpdateAttendeesCountJob < ApplicationJob
  ATTENDEES_COUNT_NOT_FOUND_MAX_ATTEMPTS = 3

  queue_as :default
  queue_with_priority 10
  limits_concurrency to: 5, key: ->(*) { self.class.name }

  retry_on Event::AttendeesCountNotFoundError, wait: 5.minutes, attempts: ATTENDEES_COUNT_NOT_FOUND_MAX_ATTEMPTS

  def perform(event_id)
    event = Event.find(event_id)
    original_markdown = event.markdown

    event.fetch
    attendees_count = event.extract_attendees_count_from_markdown

    if attendees_count.nil?
      raise Event::AttendeesCountNotFoundError.new
    end

    # revert markdown to original value
    event.markdown = original_markdown

    event.attendees_count = attendees_count
    event.attendees_count_finalized_at = Time.current
    event.save!

  rescue Event::AttendeesCountNotFoundError => e
    raise e if executions_for(e) < ATTENDEES_COUNT_NOT_FOUND_MAX_ATTEMPTS
  end
end
