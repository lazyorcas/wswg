module Event::Duplicable
  extend ActiveSupport::Concern

  SIMILARITY_THRESHOLD = 0.9

  included do
    validate :validate_not_duplicated, if: :duplicable?
  end

  def duplicable?
    location_id.present? && start_date.present? && end_date.present? && start_time.present?
  end

  def similar_events
    @similar_events ||= begin
      return [] unless duplicable?

      Event.where(
        location_id: location_id,
        start_date: start_date,
        end_date: end_date,
        start_time: start_time,
      ).excluding(self)
    end
  end

  def duplicated_event
    @duplicated_event ||= similar_events.find do |similar_event|
      title.jarowinkler_similar(similar_event.title) >= SIMILARITY_THRESHOLD
    end
  end

  def duplicated?
    duplicated_event.present?
  end

  private

  def validate_not_duplicated
    return unless duplicated?
    errors.add(:base, :duplicated, message: "duplicated with event #{duplicated_event.id}")
  end
end
