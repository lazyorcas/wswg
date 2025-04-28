class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 15.minutes, attempts: 2
  retry_on OpenAI::HallucinationError, wait: 1.minute, attempts: 3

  def perform(attributes)
    event = Event.find_or_initialize_by(
      source_id: attributes[:source_id],
      uid: attributes[:uid]
    )
    return if event.persisted?

    if event.source.name == "Luma"
      build_luma_event_uid(event)
      return if Event.exists?(source_id: event.source_id, uid: event.uid)
    end

    event.attributes = attributes

    event.fetch

    if event.valid?
      event.save!

    else
      create_archived_link(
        event.url,
        reason: event.errors.first.type,
        details: event.errors.to_json
      )
    end
  end

  private

  def build_luma_event_uid(event)
    id = Source::Luma::ThingsFinder.get_id(event.uid)
    uid = Source::Luma::ThingsFinder.build_uid(id, date: event.start_date)
    event.uid = uid
  end

  def create_archived_link(url, reason:, details: nil)
    archived_link = ArchivedLink.find_or_initialize_by(url: url)

    if archived_link.new_record?
      reason = case reason
      when :not_found_or_expired
        :not_found_or_expired
      when :duplicated
        :duplicated
      else
        :other
      end

      archived_link.reason = reason
      archived_link.details = details
      archived_link.save!
    end
  end
end
