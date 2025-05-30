module Event::Temporal
  extend ActiveSupport::Concern

  included do
    validates :end_date,
      comparison: { greater_than_or_equal_to: :start_date },
      if: -> { end_date.present? && start_date.present? }

    validates :end_time,
      comparison: { greater_than_or_equal_to: :start_time },
      if: -> { end_time.present? && start_time.present? }

    validate :validate_ongoing, if: -> { end_date.present? && start_date.present? }, on: :create
  end

  def start_datetime
    [ start_date, start_time ].join("T")
  end

  private

  def validate_ongoing
    return if ongoing?
    errors.add(:end_date, "must be greater than or equal to the current date")
  end
end
