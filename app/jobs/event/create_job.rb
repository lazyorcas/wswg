class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  # when Jina fails
  retry_on Net::ReadTimeout, wait: :polynomially_longer, attempts: 3

  # when OpenAI fails
  retry_on Faraday::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on Faraday::ServerError, wait: 15.minutes, attempts: 2

  retry_on OpenAI::HallucinationError, wait: 1.minute, attempts: 3

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

    handle_luma_event(event) if event.source.name == "Luma"

    if event.valid?
      event.locate
      event.save!

    elsif event.errors.any? { |error| error.attribute == :url && error.type == :not_found_or_expired }
      archived_link = ArchivedLink.find_or_initialize_by(url: event.url)

      if archived_link.new_record?
        archived_link.reason = :not_found_or_expired
        archived_link.save!
      end

    else
      today = Time.current.in_time_zone(event.city.time_zone).to_date

      if event.end_date == "#{today.year}-01-01"
        raise OpenAI::HallucinationError.new
      end

      raise ActiveRecord::RecordInvalid.new(event)
    end
  end

  private

  def handle_luma_event(event)
    id = Source::Luma::ThingsFinder.get_id(event.uid)
    uid = Source::Luma::ThingsFinder.build_uid(id, date: event.start_date)

    if Event.exists?(source_id: event.source_id, uid: uid)
      return
    end

    event.uid = uid
  end
end
