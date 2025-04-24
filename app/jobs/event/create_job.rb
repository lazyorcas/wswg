class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  # when Jina fails
  retry_on Net::ReadTimeout, wait: :polynomially_longer, attempts: 3

  # when OpenAI fails
  retry_on Faraday::ServerError, wait: 5.minutes, attempts: 3

  rescue_from(Event::NotFoundViaUrlError) do |exception|
    DeadLink.find_or_create_by!(url: exception.url)
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
    Rails.cache.fetch("source_#{event.source_id}_event_#{event.uid}_fetched", expires_in: 15.minutes) do
      event.fetch
    end

    event.parse

    if event.source.name == "Luma"
      id = Source::Luma::ThingsFinder.get_id(event.uid)
      uid = Source::Luma::ThingsFinder.build_uid(id, date: event.start_date)

      if Event.exists?(source_id: event.source_id, uid: uid)
        return
      end

      event.uid = uid
    end

    event.locate

    if event.valid?
      event.save!
    else
      raise ActiveRecord::RecordInvalid.new(event)
    end
  end
end
