class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  # when Jina fails
  retry_on Net::ReadTimeout, wait: :polynomially_longer, attempts: 3

  # when OpenAI fails
  retry_on Faraday::ServerError, wait: 5.minutes, attempts: 3

  # when the event is not parsed correctly
  retry_on ActiveRecord::RecordInvalid, wait: :polynomially_longer, attempts: 2

  rescue_from(ActiveRecord::RecordInvalid) do |exception|
    event = exception.record
    DeadLink.find_or_create_by!(url: event.url)
    raise exception
  end

  def perform(attributes)
    event = Event.find_or_initialize_by(
      source_id: attributes[:source_id],
      uid: attributes[:uid]
    )
    return if event.persisted?

    event.city_id = attributes[:city_id]
    event.url = attributes[:url]

    # cache the event attributes to avoid fetching the same event multiple times when the job is retried
    event.attributes = Rails.cache.fetch("source_#{event.source_id}_event_#{event.uid}_fetched", expires_in: 1.day) do
      event.fetch
      event.attributes
    end

    event.locate

    if event.valid?
      event.save!
    else
      raise ActiveRecord::RecordInvalid.new(event)
    end
  end
end
