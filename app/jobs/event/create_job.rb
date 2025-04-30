class Event::CreateJob < ApplicationJob
  queue_with_priority 3

  retry_on Jina::TimeoutError, wait: :polynomially_longer, attempts: 3

  retry_on OpenAI::TooManyRequestsError, wait: 5.minutes, attempts: 3
  retry_on OpenAI::ServerError, wait: 15.minutes, attempts: 3

  retry_on ActiveRecord::RecordInvalid, wait: 1.hour, attempts: 3

  def perform(city_source_id:, url:)
    event = Event.find_or_initialize_by(city_source_id: city_source_id, url: url)
    return if event.persisted?

    event.fetch

    build_luma_event_url(event) if event.city_source.source.name == "Luma"

    if event.valid?
      event.save!

    elsif should_retry?(reason: event.errors.first.type)
      raise ActiveRecord::RecordInvalid.new(event)

    else
      create_archived_link(
        event.url,
        reason: event.errors.first.type,
        details: event.errors.to_json
      )
    end
  end

  private

  def should_retry?(reason:)
    return false if [ :not_found_or_expired, :duplicated ].include?(reason)

    (exception_executions[ActiveRecord::RecordInvalid.to_s] || 0).zero?
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

  def build_luma_event_url(event)
    event.url = Source::Luma.build_unique_url_for_event(event)
  end
end
