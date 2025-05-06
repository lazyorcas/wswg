class Event::CreateJob < ApplicationJob
  DATA_INCOMPLETE_MAX_ATTEMPTS = 3

  queue_with_priority 3

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 5.minutes, attempts: 3

  retry_on Event::DataIncompleteError, attempts: DATA_INCOMPLETE_MAX_ATTEMPTS

  def perform(url:, **attributes)
    event = Event.find_or_initialize_by(url: url)
    return if event.persisted?

    event.attributes = attributes

    unless event.data_completed?
      event.fetch
      event.parse
    end

    if event.valid?
      event.save!

    elsif data_incomplete?(event.errors)
      raise Event::DataIncompleteError.new(event)

    elsif url_taken?(event.errors)
      nil

    elsif duplicated?(event.errors)
      create_archived_link_for_duplicated_event(event)
    end
  end

  private

  def data_incomplete?(errors)
    errors.any? { |error| error.type == :data_incomplete } &&
      (exception_executions[Event::DataIncompleteError.to_s] || 0) < DATA_INCOMPLETE_MAX_ATTEMPTS
  end

  def url_taken?(errors)
    errors.any? { |error| error.attribute == :url && error.type == :taken }
  end

  def duplicated?(errors)
    errors.any? { |error| error.type == :duplicated }
  end

  def create_archived_link_for_duplicated_event(event)
    archived_link = ArchivedLink.find_or_initialize_by(url: event.url)

    if archived_link.new_record?
      archived_link.reason = :duplicated
      archived_link.metadata = {
        attributes: event.attributes,
        errors: event.errors.to_json
      }
      archived_link.save!
    end
  end
end
