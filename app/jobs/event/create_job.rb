class Event::CreateJob < ApplicationJob
  URL_NOT_FOUND_MAX_ATTEMPTS = 3
  DATA_INCOMPLETE_MAX_ATTEMPTS = 3

  queue_as :default
  queue_with_priority 2
  limits_concurrency to: 1, key: ->(url:, **attributes) { url }, on_conflict: :discard

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 5.minutes, attempts: 3

  retry_on Event::DataIncompleteError, wait: 5.minutes, attempts: DATA_INCOMPLETE_MAX_ATTEMPTS
  retry_on Event::UrlNotFoundError, wait: 5.minutes, attempts: URL_NOT_FOUND_MAX_ATTEMPTS

  discard_on JSON::ParserError

  def perform(url:, **attributes)
    event = Event.find_or_initialize_by(url: url)
    return if event.persisted?

    event.attributes = attributes

    unless event.data_completed?
      event.fetch
      event.parse
    end

    event.locate if event.locatable?

    if event.valid?
      event.save!

    elsif data_incomplete?(event.errors)
      raise Event::DataIncompleteError.new(event)

    elsif url_taken?(event.errors)
      nil

    elsif duplicated?(event.errors)
      create_archived_link(event, :duplicated, metadata: {
        attributes: event.attributes,
        errors: event.errors.to_json
      })
    end

  rescue Event::DataIncompleteError => e
    raise e if executions_for(e) < DATA_INCOMPLETE_MAX_ATTEMPTS
    create_archived_link(event, :data_incomplete, metadata: {
      attributes: event.attributes,
      errors: event.errors.to_json
    })

  rescue Event::UrlNotFoundError => e
    raise e if executions_for(e) < URL_NOT_FOUND_MAX_ATTEMPTS
    create_archived_link(event, :url_not_found, metadata: {
      attributes: event.attributes
    })
  end

  private

  def data_incomplete?(errors)
    errors.any? { |error| error.type == :data_incomplete }
  end

  def url_taken?(errors)
    errors.any? { |error| error.attribute == :url && error.type == :taken }
  end

  def duplicated?(errors)
    errors.any? { |error| error.type == :duplicated }
  end

  def create_archived_link(event, reason, metadata: {})
    archived_link = ArchivedLink.find_or_initialize_by(url: event.url)

    if archived_link.new_record?
      archived_link.reason = reason
      archived_link.metadata = metadata
      archived_link.save!
    end
  end
end
